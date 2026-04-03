-- POETIZE 项目 PostgreSQL 数据库脚本
-- 原始 MySQL SQL 已转换为 PostgreSQL 兼容格式

-- 创建用户表
CREATE TABLE "user" (
  id SERIAL PRIMARY KEY,
  username VARCHAR(32) UNIQUE,
  password VARCHAR(128),
  phone_number VARCHAR(16),
  email VARCHAR(32),
  user_status SMALLINT NOT NULL DEFAULT 1,
  gender SMALLINT,
  open_id VARCHAR(128),
  avatar VARCHAR(256),
  admire VARCHAR(32),
  "subscribe" TEXT,
  introduction VARCHAR(4096),
  user_type SMALLINT NOT NULL DEFAULT 2,
  user_lv SMALLINT NOT NULL DEFAULT 1,
  create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  update_by VARCHAR(32),
  deleted SMALLINT NOT NULL DEFAULT 0
);

-- 创建文章表
CREATE TABLE article (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  sort_id INTEGER NOT NULL,
  label_id INTEGER NOT NULL,
  article_cover VARCHAR(256),
  article_title VARCHAR(32) NOT NULL,
  article_content TEXT NOT NULL,
  video_url VARCHAR(1024),
  view_count INTEGER NOT NULL DEFAULT 0,
  like_count INTEGER NOT NULL DEFAULT 0,
  view_type VARCHAR(16) NOT NULL DEFAULT 'public',
  view_value VARCHAR(128),
  tips VARCHAR(128),
  recommend_status SMALLINT NOT NULL DEFAULT 0,
  comment_status SMALLINT NOT NULL DEFAULT 1,
  create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  update_by VARCHAR(32),
  deleted SMALLINT NOT NULL DEFAULT 0
);

-- 创建评论表
CREATE TABLE comment (
  id SERIAL PRIMARY KEY,
  source INTEGER NOT NULL,
  type VARCHAR(32) NOT NULL,
  parent_comment_id INTEGER NOT NULL DEFAULT 0,
  user_id INTEGER NOT NULL,
  floor_comment_id INTEGER,
  parent_user_id INTEGER,
  like_count INTEGER NOT NULL DEFAULT 0,
  comment_content VARCHAR(1024) NOT NULL,
  comment_info VARCHAR(256),
  create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_comment_source ON comment(source);

-- 创建分类表
CREATE TABLE sort (
  id SERIAL PRIMARY KEY,
  sort_name VARCHAR(32) NOT NULL,
  sort_description VARCHAR(256) NOT NULL,
  sort_type SMALLINT NOT NULL DEFAULT 1,
  priority INTEGER
);

-- 创建标签表
CREATE TABLE label (
  id SERIAL PRIMARY KEY,
  sort_id INTEGER NOT NULL,
  label_name VARCHAR(32) NOT NULL,
  label_description VARCHAR(256) NOT NULL
);

-- 创建树洞表
CREATE TABLE tree_hole (
  id SERIAL PRIMARY KEY,
  avatar VARCHAR(256),
  message VARCHAR(64) NOT NULL,
  create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建微言表
CREATE TABLE wei_yan (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  like_count INTEGER NOT NULL DEFAULT 0,
  content VARCHAR(1024) NOT NULL,
  type VARCHAR(32) NOT NULL,
  source INTEGER,
  is_public SMALLINT NOT NULL DEFAULT 0,
  create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_wei_yan_user_id ON wei_yan(user_id);

-- 创建网站信息表
CREATE TABLE web_info (
  id SERIAL PRIMARY KEY,
  web_name VARCHAR(16) NOT NULL,
  web_title VARCHAR(512) NOT NULL,
  notices VARCHAR(512),
  footer VARCHAR(256) NOT NULL,
  background_image VARCHAR(256),
  avatar VARCHAR(256) NOT NULL,
  random_avatar TEXT,
  random_name VARCHAR(4096),
  random_cover TEXT,
  waifu_json TEXT,
  status SMALLINT NOT NULL DEFAULT 1
);

-- 创建资源路径表
CREATE TABLE resource_path (
  id SERIAL PRIMARY KEY,
  title VARCHAR(64) NOT NULL,
  classify VARCHAR(32),
  cover VARCHAR(256),
  url VARCHAR(256),
  introduction VARCHAR(1024),
  type VARCHAR(32) NOT NULL,
  status SMALLINT NOT NULL DEFAULT 1,
  remark TEXT,
  create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建资源表
CREATE TABLE resource (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  type VARCHAR(32) NOT NULL,
  path VARCHAR(256) UNIQUE NOT NULL,
  size INTEGER,
  original_name VARCHAR(512),
  mime_type VARCHAR(256),
  status SMALLINT NOT NULL DEFAULT 1,
  store_type VARCHAR(16),
  create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建历史信息表
CREATE TABLE history_info (
  id SERIAL PRIMARY KEY,
  user_id INTEGER,
  ip VARCHAR(128) NOT NULL,
  nation VARCHAR(64),
  province VARCHAR(64),
  city VARCHAR(64),
  create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建系统配置表
CREATE TABLE sys_config (
  id SERIAL PRIMARY KEY,
  config_name VARCHAR(128) NOT NULL,
  config_key VARCHAR(64) NOT NULL,
  config_value VARCHAR(256),
  config_type CHAR(1) NOT NULL
);

-- 创建家庭信息表
CREATE TABLE family (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  bg_cover VARCHAR(256) NOT NULL,
  man_cover VARCHAR(256) NOT NULL,
  woman_cover VARCHAR(256) NOT NULL,
  man_name VARCHAR(32) NOT NULL,
  woman_name VARCHAR(32) NOT NULL,
  timing VARCHAR(32) NOT NULL,
  countdown_title VARCHAR(32),
  countdown_time VARCHAR(32),
  status SMALLINT NOT NULL DEFAULT 1,
  family_info VARCHAR(1024),
  like_count INTEGER NOT NULL DEFAULT 0,
  create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建聊天好友表
CREATE TABLE im_chat_user_friend (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  friend_id INTEGER NOT NULL,
  friend_status SMALLINT NOT NULL,
  remark VARCHAR(32),
  create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建聊天群表
CREATE TABLE im_chat_group (
  id SERIAL PRIMARY KEY,
  group_name VARCHAR(32) NOT NULL,
  master_user_id INTEGER NOT NULL,
  avatar VARCHAR(256),
  introduction VARCHAR(128),
  notice VARCHAR(1024),
  in_type SMALLINT NOT NULL DEFAULT 1,
  group_type SMALLINT NOT NULL DEFAULT 1,
  create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建聊天群成员表
CREATE TABLE im_chat_group_user (
  id SERIAL PRIMARY KEY,
  group_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  verify_user_id INTEGER,
  remark VARCHAR(1024),
  admin_flag SMALLINT NOT NULL DEFAULT 0,
  user_status SMALLINT NOT NULL
);

-- 创建单聊记录表
CREATE TABLE im_chat_user_message (
  id BIGSERIAL PRIMARY KEY,
  from_id INTEGER NOT NULL,
  to_id INTEGER NOT NULL,
  content VARCHAR(1024) NOT NULL,
  message_status SMALLINT NOT NULL DEFAULT 0,
  create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_im_chat_user_message_union ON im_chat_user_message(to_id, message_status);

-- 创建群聊记录表
CREATE TABLE im_chat_user_group_message (
  id BIGSERIAL PRIMARY KEY,
  group_id INTEGER NOT NULL,
  from_id INTEGER NOT NULL,
  to_id INTEGER,
  content VARCHAR(1024) NOT NULL,
  create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 插入初始数据
INSERT INTO "user"(id, username, password, phone_number, email, user_status, gender, open_id, admire, "subscribe", avatar, introduction, user_type, user_lv, update_by, deleted) 
VALUES (1, 'Sara', '47bce5c74f589f4867dbd57e9ca9f808', '', '', 1, 1, '', '', '', '', '', 0, 6, 'Sara', 0);

INSERT INTO web_info(id, web_name, web_title, notices, footer, background_image, avatar, random_avatar, random_name, random_cover, waifu_json, status) 
VALUES (1, 'Sara', 'POETIZE', '[]', '云想衣裳花想容， 春风拂槛露华浓。', '', '', '[]', '[]', '[]', '{}', 1);

INSERT INTO family (id, user_id, bg_cover, man_cover, woman_cover, man_name, woman_name, timing, countdown_title, countdown_time, status, family_info, like_count, create_time, update_time) 
VALUES (1, 1, '背景封面', '男生头像', '女生头像', 'Sara', 'Abby', '2000-01-01 00:00:00', '春节倒计时', '2025-01-29 00:00:00', 1, '', 0, '2000-01-01 00:00:00', '2000-01-01 00:00:00');

INSERT INTO im_chat_group (id, group_name, master_user_id, introduction, notice, in_type) 
VALUES(-1, '公共聊天室', 1, '公共聊天室', '欢迎光临！', 0);

INSERT INTO im_chat_group_user (id, group_id, user_id, admin_flag, user_status) 
VALUES (1, -1, 1, 1, 1);

INSERT INTO sys_config (id, config_name, config_key, config_value, config_type) VALUES 
(1, 'QQ邮箱号', 'spring.mail.username', '', '1'),
(2, 'QQ邮箱授权码', 'spring.mail.password', '', '1'),
(3, '邮箱验证码模板', 'user.code.format', '【POETIZE】%s为本次验证的验证码，请在5分钟内完成验证。为保证账号安全，请勿泄漏此验证码。', '1'),
(4, '邮箱订阅模板', 'user.subscribe.format', '【POETIZE】您订阅的专栏【%s】新增一篇文章：%s。', '1'),
(5, '默认存储平台', 'store.type', 'local', '2'),
(6, '本地存储启用状态', 'local.enable', 'true', '2'),
(7, '七牛云存储启用状态', 'qiniu.enable', 'false', '2'),
(8, '本地存储上传文件根目录', 'local.uploadUrl', '/home/poetize/file/', '1'),
(9, '本地存储下载前缀', 'local.downloadUrl', '/static/', '2'),
(10, '七牛云-accessKey', 'qiniu.accessKey', '', '1'),
(11, '七牛云-secretKey', 'qiniu.secretKey', '', '1'),
(12, '七牛云-bucket', 'qiniu.bucket', '', '1'),
(13, '七牛云-域名', 'qiniu.downloadUrl', '仿照：【https://file.poetize.cn/】，将域名换成自己的七牛云ip或域名', '2'),
(15, 'IM-聊天室启用状态', 'im.enable', 'true', '1'),
(16, '七牛云上传地址', 'qiniuUrl', 'https://upload.qiniup.com', '2'),
(17, '备案号', 'beian', '', '2'),
(18, '前端静态资源路径前缀', 'webStaticResourcePrefix', '/static/', '2'),
(19, '导航栏菜单显示', 'bar.menu.show', '首页,记录,家,随笔,旅拍,百宝箱,留言,联系我,后台', '2'),
(20, '邮箱通知启用状态', 'mail.enable', 'true', '1'),
(21, '友链-网站名称', 'friendWebName', 'POETIZE', '2'),
(22, '友链-网址', 'friendUrl', 'https://poetize.cn', '2'),
(23, '友链-头像', 'friendAvatar', 'https://s1.ax1x.com/2022/11/10/z9E7X4.jpg', '2'),
(24, '友链-描述', 'friendIntroduction', '这是一个 Vue2 Vue3 与 SpringBoot 结合的产物～', '2'),
(25, '友链-网站封面', 'friendCover', 'https://s1.ax1x.com/2022/11/10/z9VlHs.png', '2');
