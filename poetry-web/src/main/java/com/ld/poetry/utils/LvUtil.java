package com.ld.poetry.utils;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

public class LvUtil {

    public static String getCreateTimeLv(LocalDateTime createTime, LocalDateTime currentTime, Integer userId) {
        LocalDate create = createTime.toLocalDate();
        LocalDate current = currentTime.toLocalDate();
        long daysDifference = ChronoUnit.DAYS.between(create, current);
        boolean select = userId % 2 == 0;
        String lv = "";
        if (daysDifference <= 1) {
            lv = select ? "铜皮" : "泥胚境";
        } else if (daysDifference <= 2) {
            lv = select ? "草根" : "木胎境";
        } else if (daysDifference <= 4) {
            lv = select ? "柳筋" : "水银境";
        } else if (daysDifference <= 8) {
            lv = select ? "骨气" : "英魂境";
        } else if (daysDifference <= 16) {
            lv = select ? "铸庐" : "雄魄境";
        } else if (daysDifference <= 32) {
            lv = select ? "洞府境" : "武胆境";
        } else if (daysDifference <= 64) {
            lv = select ? "观海境" : "金身境";
        } else if (daysDifference <= 128) {
            lv = select ? "龙门境" : "羽化境";
        } else if (daysDifference <= 256) {
            lv = select ? "金丹境" : "山巅境";
        } else if (daysDifference <= 512) {
            lv = select ? "元婴境" : "气盛境";
        } else if (daysDifference <= 1024) {
            lv = select ? "玉璞境" : "归真境";
        } else if (daysDifference <= 2048) {
            lv = select ? "仙人境" : "神到境";
        } else if (daysDifference <= 4096) {
            lv = select ? "飞升境" : "武神境";
        } else {
            lv = "失传二境";
        }
        return lv;
    }
}
