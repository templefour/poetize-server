package com.ld.poetry.config;

import com.ld.poetry.handle.PoetryRuntimeException;
import lombok.SneakyThrows;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.env.EnvironmentPostProcessor;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.core.env.MapPropertySource;
import org.springframework.core.env.MutablePropertySources;
import org.springframework.core.env.PropertySource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.core.io.support.ResourcePatternResolver;
import org.springframework.jdbc.datasource.init.ResourceDatabasePopulator;

import java.sql.*;
import java.util.HashMap;
import java.util.Map;

@Order(Ordered.LOWEST_PRECEDENCE)
public class CustomEnvironmentPostProcessor implements EnvironmentPostProcessor {

    private static final String SOURCE_NAME = "sys_config";

    private static final String SOURCE_SQL = "select * from poetize.sys_config";

    private static final String DATABASE = "poetize";

    private static final String sqlPath = "file:/home/poetize/poetry.sql";

   @Override
public void postProcessEnvironment(ConfigurableEnvironment environment, SpringApplication application) {
    Map<String, Object> map = new HashMap<>();
    
    try {
        String username = environment.getProperty("spring.datasource.username");
        String password = environment.getProperty("spring.datasource.password");
        String url = environment.getProperty("spring.datasource.url").replace("/poetize", "");
        String driver = environment.getProperty("spring.datasource.driver-class-name");
        
        // 尝试加载驱动并连接数据库
        try {
            Class.forName(driver);
            try (Connection connection = DriverManager.getConnection(url, username, password)) {
                // 初始化数据库（如果表不存在则创建）
                initDb(connection);
                // 加载配置文件到 map
                try (Statement statement = connection.createStatement()) {
                    try (ResultSet resultSet = statement.executeQuery(SOURCE_SQL)) {
                        while (resultSet.next()) {
                            map.put(resultSet.getString("config_key"), resultSet.getString("config_value"));
                        }
                    }
                }
            }
        } catch (Exception e) {
            // 记录日志，但不抛出异常，让 Spring Boot 继续启动
            System.err.println("CustomEnvironmentPostProcessor: 数据库连接失败，跳过早期配置加载。错误: " + e.getMessage());
            // e.printStackTrace(); // 如果需要详细堆栈可以取消注释
        }
    } catch (Exception e) {
        // 捕获获取配置参数时的异常（例如某个属性缺失），同样不中断启动
        System.err.println("CustomEnvironmentPostProcessor: 获取数据库配置参数失败: " + e.getMessage());
    }
    
    // 无论是否成功连接，都将 map（可能为空）添加到环境属性源中
    MutablePropertySources propertySources = environment.getPropertySources();
    PropertySource<?> source = new MapPropertySource(SOURCE_NAME, map);
    propertySources.addFirst(source);
}
    @SneakyThrows
    private void initDb(Connection connection) {
        try (Statement statement = connection.createStatement()) {
            try (ResultSet resultSet = statement.executeQuery("SHOW DATABASES LIKE '" + DATABASE + "'")) {
                if (!resultSet.next()) {
                    ResourceDatabasePopulator populator = new ResourceDatabasePopulator();
                    ResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
                    populator.addScripts(resolver.getResources(sqlPath));
                    populator.populate(connection);
                }
            }
        }
    }
}
