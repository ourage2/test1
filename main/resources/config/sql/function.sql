소스
CREATE -- added during DDL generation.
function          FN_DMBO_NAME_PASTE( P_I_KIND_CD in varchar2, P_POL_NO in varchar2, P_RCVD_SEQ_NO in number ) return varchar2 as
     v_str     varchar2(1000);
begin
 FOR CS IN (
       SELECT B.DMBO_NAME  AS DMBO_NAME
      FROM TBFB0001 A
        , (SELECT DMBO_CD, DMBO_NAME FROM TBIB0210 WHERE I_KIND_CD = '11' AND DMBO_GB IN ('1','2','4') ) B
     WHERE A.DMBO_CD = B.DMBO_CD (+)
       AND A.I_KIND_CD = P_I_KIND_CD
       AND A.POL_NO = P_POL_NO
       AND A.RCVD_SEQ_NO = P_RCVD_SEQ_NO
     )
 LOOP
     if v_str is not null  then
       v_str := v_str || ', ';
        end if;

        v_str := v_str || CS.DMBO_NAME;

 END LOOP;
    return v_str;
exception when no_data_found then
                 return '';
          when others then
                 return '';
end;
CREATE -- added during DDL generation.
FUNCTION          FN_GET_CARNO (i_han_car_no varchar2) RETURN varchar2 AS
/***************************************************************************/
/* Function 명  : 차량구분번호 가지고 오기                                 */
/* Parameter    : [ In] i_han_car_no     (서울 45 가 9876)  한글차량번호   */
/*                [Out] r_car_number_code(  01/45/11/9876/)                */
/* Description  : 시도분류/소분류1/대분류/차량번보/소분류2                 */
/***************************************************************************/
r_car_number_code varchar2(50);  /* Retrun Parameter :차량분류값 */

v_han_car_no      varchar2(50);
v_car_no          varchar2(50);
v_car_no_city     varchar2(50);  /* 차량번호시도분류(개발원 시도분류) */
v_car_no_l        varchar2(50);  /* 차량번호대분류(개발원 대분류)     */
v_car_no_s1       varchar2(50);  /* 차량번호 소분류1(개발원 소분류1)  */
v_car_no_s2       varchar2(50);  /* 차량번호 소분류2(개발원 소분류2)  */
BEGIN
    begin

        v_han_car_no := replace(i_han_car_no,' ','');

        if    regexp_substr(v_han_car_no,'[^0-9]+',1,2) is null then
              v_car_no_city  := 'NN';                                       /*차량번호 대분류(개발원 시도분류) */
              v_car_no_l     := regexp_substr(v_han_car_no,'[^0-9]+',1,1);  /*차량번호 소분류2(개발원 대분류) */
        else
              v_car_no_city  := regexp_substr(v_han_car_no,'[^0-9]+',1,1);
              v_car_no_l     := regexp_substr(v_han_car_no,'[^0-9]+',1,2);
        end if;

        if    length(regexp_substr(v_han_car_no,'[0-9]+',1,1)) = 1  then
              v_car_no_s1     := '';                                        /* 차량번호 소분류1(개발원 소분류1)  */
              v_car_no_s2     := regexp_substr(v_han_car_no,'[0-9]+',1,1);  /* 차량번호 소분류2(개발원 소분류2)  */
        else
              v_car_no_s1     := regexp_substr(v_han_car_no,'[0-9]+',1,1);
              v_car_no_s2     := 'N';
        end if;

        v_car_no := regexp_substr(v_han_car_no,'[0-9]+',1,2);               /*차량번호  */

        if    v_car_no_city <> 'NN' then
              begin
                   select CODE_CD
                     into v_car_no_city
                     from TBZZ1000
                    where CODETYPE   = 'A0040'
                      and CODE_NAME  like v_car_no_city || '%'
                      and CODE_GUBUN = '00'
                      and rownum     = 1;

                    exception when no_data_found then v_car_no_city := '';
              end;
        end if;

        if    v_car_no_l is not null then
              begin
                     select CODE_CD
                     into v_car_no_l
                     from TBZZ1000
                    where CODETYPE  = 'A0063'
                      and CODE_NAME = v_car_no_l
                      and rownum    = 1;

                    exception when no_data_found then v_car_no_l := '';
              end;

        end if;


        r_car_number_code := v_car_no_city || '/' || v_car_no_s1 || '/' || v_car_no_l || '/' || v_car_no || '/' || v_car_no_s2;

        exception when others then
                  r_car_number_code := '////';
    end;
    return (r_car_number_code );
END;
CREATE -- added during DDL generation.
function          FN_GET_CAR_STATE
(i_gubun         varchar2
,i_cust_no       varchar2
,i_car_seq       number
,i_car_id        varchar2) return varchar2 as

/***************************************************************************/
/* Function 명  : 차량구분번호 가지고 오기                                 */
/* Parameter    : [ In] i_gubun      조회구분                              */
/*                [ In] i_cust_no    고객번호                              */
/*                [ In] i_car_seq    차량순번                              */
/*                [ In] i_car_id     차대번호                              */
/*                [Out] r_return                                           */
/* Description  : 시도분류/소분류/대분류/차량번보                          */
/***************************************************************************/
r_return            varchar2(200);/* Retrun Parameter :고객번호 또는 증권번호 */

BEGIN
    begin
        if    i_gubun = '1' then  /* 출자금 여부 */
              select CUST_NO
                into r_return
                from TBAA0101
               where CUST_NO    = i_cust_no
                 and (CAR_ID    = i_car_id or HAN_CAR_NO = i_car_id)
                 and CNTR_GB    = '1'
                 and rownum     = 1 ;
        elsif i_gubun = '2' then  /* 차량존재 여부 */
              select CUST_NO
                into r_return
                from TBAA0101
               where CUST_NO    = i_cust_no
                 and (CAR_ID    = i_car_id or HAN_CAR_NO = i_car_id)
                 and USE_YN = 'Y'
                 and rownum = 1 ;
         elsif i_gubun = '3' then  /* 계약존재 여부 */
              select POL_NO ||'-' || CAR_HAN_NO ||'-' || CAR_ID ||'-' || CAR_SEQ
                into r_return
                from TBIC0001
               where CUST_NO          = i_cust_no
                 and CAR_SEQ          = i_car_seq
                 AND i_kind_cd = '11'
                 --and ISTAR_CONT_DATE <= sysdate
                 --and IEND_CONT_DATE  >= sysdate
                 and IEND_CONT_DATE  > sysdate
                 and CONT_STATE      in ('02','03','05')
                 and rownum           = 1;
        else
                r_return  :='Err1';
        end if;

        exception when no_data_found then r_return := null;
     end;

    return (r_return );
END;
CREATE -- added during DDL generation.
FUNCTION          FN_GET_CASE_SEQ (i_gubun VARCHAR2) RETURN VARCHAR2 AS

/**************************************************************************************************************
PROJECT NAME  : 한국렌트카공제조합
DBMS          : Oracle11g
DATABASE      : KRCA
INPUT PARAM   : i_gubun = 시퀀스 업무구분('C':카드승인요청, 'V':가상계좌입금, 'B':배치처리, 'C':업무결제ID)
OUT PARAM     : r_seq = 업무별생성된시컨스정보
              :
DESCRIPTION   : 대외계연계 및 배치처리 관련 시컨스정보를 생성하여 반환한다.
ETC           :
**************************************************************************************************************
Modification Information
Date          Developer           Content
-------       -------------       ---------------------------
2013.08.08    이용한              CREATE
----------------------------------------------------------------------------------------------------
* Copyright (C) 2013 by MPC Corp. All rights reserved.
**************************************************************************************************************/
r_seq     varchar2(16);

BEGIN
    SELECT i_gubun || TO_CHAR(SYSDATE,'YYMMDDHH24MISS') || TRIM(TO_CHAR(SEQUENCE_CODE.NEXTVAL,'000')) INTO r_seq FROM DUAL;
    RETURN (r_seq);
END;
CREATE -- added during DDL generation.
FUNCTION          FN_GET_CHANGE_CHECK(i_pol_no varchar2,i_endor_no number, i_endor_sub_seq number ) RETURN varchar2 AS
/***************************************************************************/
/* Function 명  : 배서데이터 변경사항 찾기(개발원 전송시 변경여부 확인)    */
/* Parameter    : [ In] i_pol_no         증권번호                          */
/*                [ In] i_endor_no       배서번호                          */
/*                [Out] change_group     변경그룹                          */
/* Description  :                                                          */
/***************************************************************************/
    rtn_group_04          number := 0;                     --피보험자 그룹
    rtn_group_05          number := 0;                     --계약자 그룹
    rtn_group_06          number := 0;                     --피보험자동차정보1 그룹
    rtn_group_07          number := 0;                     --피보험자동차정보2 그룹
    rtn_group_08          number := 0;                     --대인I 담보 그룹
    rtn_group_09          number := 0;                     --대물담보 그룹
    rtn_group_10          number := 0;                     --대인II 담보 그룹
    rtn_group_12          number := 0;                     --피보험자연락처 그룹
    rtn_group_13          number := 0;                     --계약자연락처 그룹
    rtn_group_etc         number := 0;                     --기타
    V_ENDOR_CD            varchar2(4);                     --배서코드
    V_ENDOR_GB            varchar2(2);                     --배서구분
    rtn_val               varchar2(100);                   --RETURN VALUE

begin
    --계약변경이력명세 테이블 검색
    for rec in ( select ENDOR_CD, DETAIL_ITEM
                   from TBIC0203
                  where POL_NO        = i_pol_no
                    and ENDOR_NO      = i_endor_no
                    and ENDOR_SUB_SEQ = i_endor_sub_seq )
    loop
        --변경된 항목별 그룹 카운트 증가
        case rec.DETAIL_ITEM
            when 'ISD_NAME'    then rtn_group_04 := rtn_group_04 + 1;
            when 'ISD_P_CDGB'  then rtn_group_04 := rtn_group_04 + 1;
            when 'ISD_CD'      then rtn_group_04 := rtn_group_04 + 1;
            when 'CONT_NAME'   then rtn_group_05 := rtn_group_05 + 1;
            when 'CONT_CD_GB'  then rtn_group_05 := rtn_group_05 + 1;
            when 'CONT_CD'     then rtn_group_05 := rtn_group_05 + 1;
            when 'CAR_ID_GB'   then rtn_group_06 := rtn_group_06 + 1;
            when 'CAR_ID'      then rtn_group_06 := rtn_group_06 + 1;
            when 'CAR_HAN_NO'  then rtn_group_06 := rtn_group_06 + 1;
            when 'CAR_USE'     then rtn_group_07 := rtn_group_07 + 1;
            when 'CAR_KIND_CD' then rtn_group_07 := rtn_group_07 + 1;
            when 'CAR_Y_TYPE'  then rtn_group_07 := rtn_group_07 + 1;
            when 'CAR_NM'      then rtn_group_07 := rtn_group_07 + 1;
            when 'DMBO_01'     then rtn_group_08 := rtn_group_08 + 1;
            when 'DMBO_02'     then rtn_group_09 := rtn_group_09 + 1;
            when 'DMBO_13'     then rtn_group_13 := rtn_group_13 + 1;
            when 'ISD_ZIP_CD'  then rtn_group_12 := rtn_group_12 + 1;
            when 'ISD_ADDR_1'  then rtn_group_12 := rtn_group_12 + 1;
            when 'ISD_ADDR_2'  then rtn_group_12 := rtn_group_12 + 1;
            when 'ISD_HP_NO'   then rtn_group_12 := rtn_group_12 + 1;
            when 'CONT_ZIP_CD' then rtn_group_13 := rtn_group_13 + 1;
            when 'CONT_ADDR_1' then rtn_group_13 := rtn_group_13 + 1;
            when 'CONT_ADDR_2' then rtn_group_13 := rtn_group_13 + 1;
            when 'CONT_HP_NO'  then rtn_group_13 := rtn_group_13 + 1;
            else rtn_group_etc := rtn_group_etc + 1;
        end case;

        V_ENDOR_CD := rec.ENDOR_CD;
    end loop;

    --배서구분코드(배서코드 앞에 한자리)
    V_ENDOR_GB:= substr(V_ENDOR_CD, 1, 1);

    --책임담보 변경여부 확인
    --취소, 해지(임의 제외), 공백기간환급, 차량대체, 분납부활  일 경우에는 책임담보가 변경된 것으로 체크한다.
    if V_ENDOR_GB = '3' or V_ENDOR_GB = '6' or V_ENDOR_GB = '7' or V_ENDOR_GB = '5' then                 --취소배서, 공백기간 환급, 분납부활, 환입 추가
     if V_ENDOR_CD <> '502' then                                                    --환입(보상용 제외)
        rtn_group_08 := rtn_group_08 + 1;
        rtn_group_09 := rtn_group_09 + 1;
        rtn_group_10 := rtn_group_10 + 1;
   end if;
    elsif V_ENDOR_GB = '4' then                                                      --해지배서
        if V_ENDOR_CD <> '404' then                                                    --임의해지
            rtn_group_08 := rtn_group_08 + 1;
            rtn_group_09 := rtn_group_09 + 1;
            rtn_group_10 := rtn_group_10 + 1;
        end if;
    elsif V_ENDOR_CD = '104' or V_ENDOR_CD = '204'  or V_ENDOR_CD = '111' or V_ENDOR_CD = '211'  then                              --차량대체
        rtn_group_08 := rtn_group_08 + 1;
        rtn_group_09 := rtn_group_09 + 1;
        rtn_group_10 := rtn_group_10 + 1;
    end if;

    rtn_val := '000';

    if rtn_group_04 > 0 then
        rtn_val := rtn_val || '1';
    else
        rtn_val := rtn_val || '0';
    end if;

    if rtn_group_05 > 0 then
        rtn_val := rtn_val || '1';
    else
        rtn_val := rtn_val || '0';
    end if;

    if rtn_group_06 > 0 then
        rtn_val := rtn_val || '1';
    else
        if V_ENDOR_GB = '1' or V_ENDOR_GB = '2' or V_ENDOR_GB = '6' then
            rtn_val := rtn_val || '1';                                               --정정, 변경, 공백기간환급일때는 무조건 변경으로 전송해야한다고 함.
        else
            rtn_val := rtn_val || '0';
        end if;
    end if;

    if rtn_group_07 > 0 then
        rtn_val := rtn_val || '1';
    else
        if V_ENDOR_GB = '1' or V_ENDOR_GB = '2' or V_ENDOR_GB = '6' then
            rtn_val := rtn_val || '1';                                               --정정, 변경, 공백기간환급일때는 무조건 변경으로 전송해야한다고 함.
        else
            rtn_val := rtn_val || '0';
        end if;
    end if;

    if rtn_group_08 > 0 then
        rtn_val := rtn_val || '1';
    else
        rtn_val := rtn_val || '0';
    end if;

    if rtn_group_09 > 0 then
        rtn_val := rtn_val || '1';
    else
        rtn_val := rtn_val || '0';
    end if;

    if rtn_group_10 > 0 then
        rtn_val := rtn_val || '1';
    else
        rtn_val := rtn_val || '0';
    end if;

    rtn_val := rtn_val || '0';

    if rtn_group_12 > 0 then
        rtn_val := rtn_val || '1';
    else
        rtn_val := rtn_val || '0';
    end if;

    if rtn_group_13 > 0 then
        rtn_val := rtn_val || '1';
    else
        rtn_val := rtn_val || '0';
    end if;

    RETURN rtn_val;

END;
CREATE -- added during DDL generation.
function          FN_GET_CHANGE_WON
(i_won           varchar2
,i_seq           number
) return varchar2 as
/***************************************************************************/
/* Function 명  : 금액 숫자로 환산하기                                     */
/* Parameter    : [ In] i_won        한글 금액                             */
/*                [Out] r_return                                           */
/* Description  :                                                          */
/***************************************************************************/
r_return    number(16);             /* Retrun Parameter :숫자 금액 */
s_won       varchar2(50);
s_seq       number(16);

idx1        number(5)     := 1;
i_len       number(16)    := 0;
s_1         varchar2(50)  := '0';
w_1         number(16)    := 1000000;
t_won       number(16)    := 0;

BEGIN
    begin
        s_seq   := nvl(i_seq,1);

        s_won   :=  regexp_substr(i_won ,'[^/]+',1,s_seq);
        s_won   :=  replace(s_won,' ' ,null);

        if    regexp_substr(s_won,'[천원,만원]+')  not in  ('천원','만원') then
              s_won   :=  replace(s_won,'원',null);
        end if;

        if    s_won is not null then
              i_len   :=  length(s_won);
         end if;

           if  s_won   = '무한' then
                 idx1    := 99;
                 w_1     :=  0;
                 t_won   :=  999999999999999 ;
           elsif ascii(substr(s_won,1,1)) < 48 or  ascii(substr(s_won,1,1)) > 57 then
                 idx1    := 99;
                 w_1     :=  0;
                 t_won   :=  0 ;
           end if;

        Loop
            if    idx1 > i_len or idx1 > 30  then
                  exit;
            end if;

            if    (ascii(substr(s_won,idx1,1)) >= 48 and ascii(substr(s_won,idx1,1)) <= 57) or ascii(substr(s_won,idx1,1)) = '46' then
                  s_1  := s_1 || substr(s_won,idx1,1);
            else
                  if    substr(s_won,idx1,2) = '만원' then
                        idx1 := idx1 + 1;
                        w_1  := 10000;
                  elsif substr(s_won,idx1,2) = '천원' then
                        idx1 := idx1 + 1;
                        w_1  := 1000;
                  elsif substr(s_won,idx1,1)  = '억'   then
                        w_1  := 100000000;
                  elsif substr(s_won,idx1,2)  = '천만' then
                        idx1 := idx1 + 1;
                        w_1  := 10000000;
                  elsif substr(s_won,idx1,1)  = '천'   then
                        w_1  := 10000000;
                  elsif substr(s_won,idx1,2)  = '백만' then
                        idx1 := idx1 + 1;
                        w_1  := 1000000;
                  elsif substr(s_won,idx1,1)  = '백'   then
                        w_1  := 1000000;
                  elsif substr(s_won,idx1,2)  = '십만' then
                        idx1 := idx1 + 1;
                        w_1  := 100000;
                  elsif substr(s_won,idx1,1)  = '십'   then
                        w_1  := 100000;
                  elsif substr(s_won,idx1,1)  = '만'   then
                        w_1  := 10000;
                  else
                        w_1  := 1000;
                  end if;

                  if    s_1  = '0' then
                        s_1 := '1' ;
                  end if;

                  t_won   := t_won + (to_number(s_1) * w_1);
                  s_1     := '0';
                  w_1     := 0;
            end if;

            idx1 := idx1 + 1;

        End Loop;

        r_return   := t_won + (to_number(s_1) * w_1);

        exception when others then r_return := 090709070907;
     end;

    return (r_return );

END;
CREATE OR REPLACE -- added during DDL generation.
FUNCTION          FN_GET_CODENAME
(i_codetype varchar2
,i_code_cd  varchar2
,i_code_gubun varchar2) RETURN varchar2 deterministic result_cache AS
/******************************************************************************
   NAME:       FN_GET_CODENAME
   PURPOSE:    공통 코드명 가져오기

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        2013-07-22          1. Created this function.

   NOTES:
   Paremeter :  [in] i_codetype ('A0001')   코드타입
                [in] i_cdoe_cd ('01')       코드
                [in] i_code_gubun('1')      코드구분
                [out]r_codename('메리츠화재') 코드명

   Automatically available Auto Replace Keywords:
      Object Name:     FN_GET_CODENAME
      Sysdate:         2013-07-22
      Date and Time:   2013-07-22, 오후 2:44:36, and 2013-07-22 오후 2:44:36
      Username:         (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
r_codename      Varchar2(50);           /*Return Parameter : 코드명 */
BEGIN
    begin
        select CODE_NAME
        into r_codename
        from TBZZ1000
        where CODETYPE = i_codetype
        and CODE_CD = i_code_cd
        and CODE_GUBUN = decode(i_code_gubun,null,CODE_GUBUN,i_code_gubun)
        and rownum = 1;

       exception when no_data_found then
        r_codename := i_code_cd;
   end;
   return (r_codename);
END;
CREATE OR REPLACE -- added during DDL generation.
FUNCTION          FN_GET_CODENAME1
(i_codetype       varchar2
,i_code_cd        varchar2) RETURN varchar2 deterministic result_cache AS
/***************************************************************************/
/* Function 명  : 보상 코드명 가지고오기                                   */
/* Parameter    : [ In] i_codetype  ('C0001')     코드타입                 */
/*                [ In] i_code_cd   ('11')        코드                     */
/*                [Out] r_codename ('메리츠화재') 코드명                   */
/* Description  :                                                          */
/***************************************************************************/
r_code_div2_name     varchar2(60);   /* Retrun Parameter : 코드명 */

BEGIN
    begin
        select CODE_DIV2_NAME  into r_code_div2_name
          from TBCZ0002
         where CODE_TYPE     = i_codetype
           and CODE_CD       = i_code_cd;

        exception when no_data_found then
                  r_code_div2_name := i_code_cd;
    end;
    return (r_code_div2_name );
END;
CREATE OR REPLACE -- added during DDL generation.
FUNCTION          FN_GET_CODENAME_CLM
(i_codetype       varchar2
,i_code_cd        varchar2
,i_code_gubun     varchar2) RETURN varchar2 deterministic result_cache AS
/***************************************************************************/
/* Function 명  : 공통 코드명 가지고오기(보상공통)                         */
/* Parameter    : [ In] i_codetype  ('A0001')     코드타입                 */
/*                [ In] i_code_cd   ('01')        코드                     */
/*                [ In] i_code_gubun('1')         코드구분                 */
/*                [Out] r_codename ('메리츠화재') 코드명                   */
/* Description  :                                                          */
/***************************************************************************/
r_code_div2_name     varchar2(200);    /* Retrun Parameter : 코드명 */

BEGIN
    begin
        select CODE_DIV2_NAME
          into r_code_div2_name
          from TBCZ0002
         where CODE_TYPE    = i_codetype
           and CODE_CD      = i_code_cd
           and CODE_GUBUN   = decode(i_code_gubun,null,CODE_GUBUN,i_code_gubun)
           and rownum = 1;

        exception when no_data_found then
                  r_code_div2_name := i_code_cd;
    end;

    return (r_code_div2_name);
END;
CREATE or replace -- added during DDL generation.
FUNCTION          FN_GET_DEPTNAME
(i_deptcd        varchar2
,i_opendate      date
,i_closedate     date) RETURN varchar2 deterministic result_cache AS
/***************************************************************************/
/* Function 명  : 부서명 가지고오기                                        */
/* Parameter    : [ In] i_deptcd         부서코드                          */
/*                [ In] i_opendate       부서 open 일자                    */
/*                [ In] i_closedate      부서 close 일자                   */
/*                [Out] r_deptname       부서명                            */
/* Description  :                                                          */
/***************************************************************************/
r_deptname     varchar2(50); /* Retrun Parameter :부서명 */

BEGIN
    begin

        select DPT_NM  into r_deptname
          from TBZZ0202
         where DPT_CD         = i_deptcd
           and DPT_OPENDATE   <= decode(i_opendate ,null,sysdate,i_opendate)
           and DPT_CLOSEDATE  >= decode(i_closedate,null,sysdate,i_closedate)
           and rownum = 1;

        exception when no_data_found then
                  r_deptname := i_deptcd;
    end;
    return (r_deptname );
END;
CREATE -- added during DDL generation.
function FN_GET_DMBONAME( P_I_KIND_CD in varchar2, P_DMBO_GB in varchar2, P_DBMO_CD in varchar2, P_APPY_FROM in date default sysdate ) return varchar2 as
     v_str     TBIB0210.DMBO_NAME%TYPE;
begin
    SELECT DECODE(DMBO_BG, NULL, DMBO_NAME
                           ,   '', DMBO_NAME
                                 , DMBO_NAME || '(' || DMBO_BG || ')' )
      INTO v_str
      FROM TBIB0210 A
     WHERE I_KIND_CD  = P_I_KIND_CD
       AND DMBO_GB    = NVL(P_DMBO_GB, DMBO_GB)
       AND DMBO_CD    = P_DBMO_CD
       AND APLY_DATE <= P_APPY_FROM
       AND APLY_EYMD >= P_APPY_FROM;

    return v_str;
exception when no_data_found then
                 return P_DBMO_CD;
          when others then
                 return '';
end;
CREATE -- added during DDL generation.
function FN_GET_FORMAT_JUMIN (i_jumin   varchar2,i_gubun varchar2 ) return varchar2 as
r_return     varchar2(20);             /* Retrun Parameter :주민(사업)번호 Format */
s_jumin      varchar2(20);

BEGIN
    begin
        s_jumin      := replace(replace(i_jumin,'-',''),'/','');

        if    i_gubun = 1 then
              s_jumin := substr(s_jumin,1,6) || '-' || substr(s_jumin,7,1) || '******';
        else
              s_jumin := substr(s_jumin,1,3) || '-' || substr(s_jumin,4,2) || '-' || substr(s_jumin,6,5);
        end if;

        r_return := s_jumin;

        exception when others then r_return := i_jumin;
    end;
    return (r_return );

END;
CREATE -- added during DDL generation.
function          FN_GET_FORMAT_TELNO (i_telno   varchar2 ) return varchar2 as
/***************************************************************************/
/* Function 명  : 전화번호 Formatting                                      */
/* Parameter    : [ In] i_telno        전화번호                            */
/*                [Out] r_return                                           */
/* Description  :                                                          */
/***************************************************************************/
r_return     varchar2(20);             /* Retrun Parameter :전화번호 Format */
s_telno      varchar2(20);
s_tel1       varchar2(10);
s_tel2       varchar2(10);
s_tel3       varchar2(10);
s_tel_serial varchar2(200);
s_length     number(3);

BEGIN
    begin

          s_telno      := i_telno;
          s_telno      := replace(s_telno,' ','');
          s_length     := length(s_telno);

          if    s_length >= 7 and s_length <= 12 then
                if  substr(s_telno,1,1) = '0' then
                    if   substr(s_telno,1,2) = '02' then
                         s_tel1 := substr(s_telno,1,2);
                           s_tel2 := substr(s_telno,3,s_length - 6);
                         s_tel3 := substr(s_telno,s_length - 3,4);
                    else
                         s_tel1 := substr(s_telno,1,3);
                           s_tel2 := substr(s_telno,4,s_length - 7);
                         s_tel3 := substr(s_telno,s_length - 3,4);
                    end if;
                else
                    s_tel1 := null;
                    s_tel2 := substr(s_telno,1,s_length-4);
                    s_tel3 := substr(s_telno,s_length - 3,4);

                end if;

                if    s_tel1 is null then
                      r_return := s_tel2 || '-' || s_tel3 ;
                else
                      r_return := s_tel1 || '-' || s_tel2 || '-' || s_tel3 ;
                end if;

           else
                r_return := i_telno;
           end if;
           exception when others then r_return := i_telno;
     end ;

     return (r_return );

END;
CREATE -- added during DDL generation.
FUNCTION          FN_GET_HND_COVER_NM (i_accidentNo VARCHAR2)
RETURN VARCHAR2 AS r_hndCoverNm     VARCHAR2(50);
BEGIN
    begin

   SELECT
         (SELECT COUNT(HND_COVER)
            FROM TBCC0001
           WHERE ACCIDENT_NO = i_accidentNo
             AND LAST = 'Y'
         )
         || '/' ||
         (SELECT COUNT(HND_COVER)
            FROM TBCD0001
           WHERE ACCIDENT_NO = i_accidentNo
             AND LAST = 'Y'
         ) into r_hndCoverNm -- 담보건수
    FROM DUAL;

        EXCEPTION WHEN NO_DATA_FOUND THEN
            r_hndCoverNm := i_accidentNo;
    end;
return (r_hndCoverNm );
END;
CREATE -- added during DDL generation.
FUNCTION          FN_GET_JOBNAME (i_code_cd VARCHAR2) RETURN VARCHAR2 AS
r_codename     VARCHAR2(100);
BEGIN
    begin
        select    RTRIM(CODE_GUBUN_NAME) ||'[' || RTRIM(CODE_NAME) || ']'    into r_codename
          from    TBZZ1001
         where    CODETYPE     = 'J004'
           and    CODE_CD         = i_code_cd ;

        EXCEPTION WHEN NO_DATA_FOUND THEN
            r_codename := i_code_cd;
    end;
return (r_codename );
END;
CREATE -- added during DDL generation.
FUNCTION FN_GET_PUSH_SEQ RETURN VARCHAR2 AS

/**************************************************************************************************************
PROJECT NAME  : 한국렌트카공제조합
DBMS          : Oracle11g
DATABASE      : KRCA
OUT PARAM     : r_seq = 푸시메시지 SEQ ID
              :
DESCRIPTION   :
ETC           :
**************************************************************************************************************
Modification Information
Date          Developer           Content
-------       -------------       ---------------------------
2014.03.13    이용한              CREATE
----------------------------------------------------------------------------------------------------
* Copyright (C) 2013 by MPC Corp. All rights reserved.
**************************************************************************************************************/
r_seq     varchar2(18);

BEGIN
    SELECT TO_CHAR(SYSDATE,'YYMMDDHH24MISS') || TRIM(TO_CHAR(SQ_TBPUSHLOG.NEXTVAL,'0000')) INTO r_seq FROM DUAL;
    RETURN (r_seq);
END;

CREATE OR REPLACE -- added during DDL generation.
FUNCTION FN_GET_SEQ (i_gubun VARCHAR2) RETURN VARCHAR2 AS
/**************************************************************************************************************************/
/* Function 명  : 각종 번호 채번                                                                                          */
/* In Parameter : i_gubun                                                                                                 */
/* Description  : In Parameter 구성                                                                                       */
/*                고객번호-조합           ('M0120')          'M'+지역조합구분(2)+사업소재지(2)                            */
/*                고객번호-고객           ('B')              'B'                                                          */
/*                가입설계                ('A101')           'A'+상품(2)+설계구분(1)                                      */
/*                증권번호                ('P101')           'P'+상품(2)+영수구분(1)                                      */
/*                계약번호                ('C101')           'C'+상품(2)+계약구분(1)                                      */
/*                영수증번호              ('R101')           'R'+상품(2)+영수구분(1)                                      */
/*                보상접수번호            ('G')              'G'+계약구분(1)                                              */
/*                소송번호                ('H')              'H'                                                          */
/*                구상번호                ('I')              'I'                                                          */
/*                민원번호                ('J')              'J'                                                          */
/*                업무처리기준관리번호    ('SC07')           'S' (추가-최범주 20150909)                                  */
/*                즉시출금요청번호        ('K')              'K' (추가-최범주 20150925)                                 */
/*                즉시출금전문번호        ('T08820150925')   'T' (추가-최범주 20150925)  'T' + 은행코드(3) + 전송일자(8)   */
/*                PG한도관리번호          ('V')              'V' (추가-최범주 20150811)                                 */
/*                결재번호                ('W')              'W' (추가-최범주 20150817)                                   */
/*                출자금납입영수          ('Z')              'Z'                                                      */
/*                배서처리번호            ('E')              'E' (추가 - ljm 20150921)                                  */
/*                TASK ID                 ('D')              'D' (추가 - ljh 20151029)                          */
/*                지시번호                ('F')              'F' (추가 - ljh 20151103)                                    */
/*                관리번호                ('L')              'L' (추가 - ljm 20160218)                                    */
/*      관리번호    ('Q')    'Q' (추가 - kdh 20170328)         */
/*                채권가압류번호      ('N')              'N' (추가 - min 20160304)                                    */
/*                계약민원관리번호      ('O')             'N' (추가 - min 20160420)                                  */
/*                합의금산출번호         ('U')             'U' (추가 - yoo 20160503)                                  */
/*                결재번호(계약)         ('X')             'X' (추가 - kim 20170317)                                  */
/**************************************************************************************************************************/

v_gubun   varchar2(14);
v_seq     number(7,0);
r_seq     varchar2(22);

PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN

    begin
        if substr(i_gubun,1,1) in ('A','P','C','R','E','L','O','Q') then
            v_gubun := substr(i_gubun,1,1) || to_char(sysdate,'YYMM') ;

        elsif substr(i_gubun,1,1) = 'M' then
            v_gubun := substr(i_gubun,1,5) ;

        elsif substr(i_gubun,1,1) = 'B' then
            v_gubun := substr(i_gubun,1,1) ;

        elsif substr(i_gubun,1,1) in ('G') then
            v_gubun := substr(i_gubun,1,2) || to_char(sysdate,'YYMMDD') ;

        elsif substr(i_gubun,1,1) = ('H') then
            v_gubun := substr(i_gubun,1,1) || to_char(sysdate,'YYYY') ;

        elsif substr(i_gubun,1,1) = ('I') then
            v_gubun := substr(i_gubun,1,1) || to_char(sysdate,'YYYYMM') ;

        elsif substr(i_gubun,1,1) = ('J') then
            v_gubun := substr(i_gubun,1,1) || to_char(sysdate,'YY') ;

        elsif substr(i_gubun,1,1) = ('S') then
            v_gubun := substr(i_gubun,1,1) || substr(i_gubun, 2, 3);

        elsif substr(i_gubun,1,1) = ('T') then
            v_gubun := i_gubun;

        elsif substr(i_gubun,1,1) = ('V') then
            v_gubun := i_gubun || to_char(sysdate, 'YYYYMMDD');

        elsif substr(i_gubun,1,1) in ('K', 'W','X') then
            v_gubun := substr(i_gubun,1,1) || to_char(sysdate,'YYMMDD');

        elsif substr(i_gubun,1,1) = ('Z') then
            v_gubun := to_char(sysdate,'YYYY') ;

        elsif substr(i_gubun,1,1) in ('D', 'F') then
            v_gubun := i_gubun ;

  elsif substr(i_gubun,1,1) = ('N') then
            v_gubun := i_gubun || to_char(sysdate,'YYYY') ;

        else
            v_gubun :=substr(i_gubun,1,5) ;
        end if;


        select KEY_SEQ+1
          into v_seq
          from TBZZ0001
         where KEY_GUBUN = v_gubun for update;

        exception when no_data_found then
                  v_seq := 1;
    end;

    if    v_seq = 1 then
          insert into TBZZ0001(KEY_GUBUN,KEY_SEQ) values(v_gubun,v_seq);
    else
          update TBZZ0001 set KEY_SEQ = v_seq where KEY_GUBUN = v_gubun;
    end if;

    commit;

    /* 가입/증권/계약 번호 */
    if    substr(i_gubun,1,1) in ('A','P','C') then
        if    to_char(sysdate,'yyyymmdd') > '20130600' then
            r_seq := i_gubun || to_char(sysdate,'YYMM') || lpad(v_seq,5,'0') || '0' ;
        else
            r_seq := i_gubun || to_char(sysdate,'YYMM') || lpad(v_seq,6,'0') ;
        end if;

    /* 영수 번호 */
    elsif substr(i_gubun,1,1) = 'R' then
        r_seq := i_gubun || to_char(sysdate,'YYMM') || lpad(v_seq,6,'0') ;

    /* 고객번호(보유자코드)-조합 */
    elsif substr(i_gubun,1,1) = 'M' then
        r_seq := v_gubun || lpad(v_seq,4,'0') ;

    /* 고객번호(보유자코드)-고객 */
    elsif substr(i_gubun,1,1) = 'B' then
        r_seq := v_gubun || lpad(v_seq,8,'0') ;

    /* 보상접수번호  */
    elsif substr(i_gubun,1,1) = 'G' then
        --일일자차 계약일 경우
        if    substr(i_gubun,2,1) = '2' then
            r_seq := to_char(sysdate,'YYMMDD') || substr(i_gubun,1,1) || lpad(v_seq,3,'0') ;
        else
            r_seq := to_char(sysdate,'YYMMDD') || lpad(v_seq,4,'0') ;
        end if;

    /* 소송번호  */
    elsif substr(i_gubun,1,1) = 'H' then
        r_seq := to_char(sysdate,'YYYY')     || lpad(v_seq,4,'0') ;

    /* 구상번호  */
    elsif substr(i_gubun,1,1) = 'I' then
        r_seq := to_char(sysdate,'YYYYMM')   || lpad(v_seq,3,'0') ;

    /* 민원번호  배서처리번호*/
    elsif substr(i_gubun,1,1) in ('J','E','O') then
        r_seq := to_char(sysdate,'YYMM')     || lpad(v_seq,5,'0') ;

    /* 업무처리기준관리번호  */
    elsif substr(i_gubun,1,1) = 'S' then
        r_seq := v_gubun || lpad(v_seq, 10, '0');

    /* 즉시출금전문번호 */
    elsif substr(i_gubun,1,1) = 'T' then
        r_seq := lpad(v_seq, 6, '0');

    /* PG한도관리번호  */
    elsif substr(i_gubun,1,1) = 'V' then
        r_seq := v_gubun || lpad(v_seq, 5, '0');

    /* 즉시출금요청번호, 결재번호 */
    elsif substr(i_gubun,1,1) in ('K', 'W', 'X') then
        r_seq := i_gubun || to_char(sysdate, 'YYYYMMDD') || lpad(v_seq, 5, '0');

    /* 출자금납입영수증  */
    elsif substr(i_gubun,1,1) = 'Z' then
        r_seq := to_char(sysdate,'YYYY')  ||'-' || lpad(v_seq,4,'0') ;

    elsif substr(i_gubun,1,1) = 'F' then
        r_seq := v_gubun || lpad(v_seq,4,'0') ;

 /* 채권가압류번호 */
 elsif substr(i_gubun,1,1) = 'N' then
        r_seq := to_char(sysdate,'YYYY') || lpad(v_seq,6,'0') ;

    else
        r_seq := v_gubun || lpad(v_seq,6,'0') ;
    end if;

    return ( r_seq );
END;
CREATE -- added during DDL generation.
FUNCTION FN_GET_SEQ_DATA_TRANS (i_gubun VARCHAR2, i_date VARCHAR2) RETURN VARCHAR2 AS
/******************************************************************************/
/* Function 명  : 각종 번호 채번                                              */
/* In Parameter : i_gubun                                                     */
/* Description  : In Parameter 구성                                           */
/*                고객번호-조합   ('M0120')  'M'+지역조합구분(2)+사업소재지(2)*/
/*                고객번호-고객   ('B')      'B'                              */
/*                가입설계        ('A101')   'A'+상품(2)+설계구분(1)          */
/*                증권번호        ('P101')   'P'+상품(2)+영수구분(1)          */
/*                계약번호        ('C101')   'C'+상품(2)+계약구분(1)          */
/*                영수증번호      ('R101')   'R'+상품(2)+영수구분(1)          */
/*                보상접수번호    ('G')      'G'+계약구분(1)                  */
/*                소송번호        ('H')      'H'                              */
/*                구상번호        ('I')      'I'                              */
/*                민원번호        ('J')      'J'                              */
/*                PG한도관리번호  ('V')      'V' (추가-최범주 20150811)       */
/*                결재번호        ('W')      'W' (추가-최범주 20150817)       */
/*                출자금납입영수  ('Z')      'Z'                              */
/******************************************************************************/
v_gubun   varchar2(14);
v_seq     number(7,0);
r_seq     varchar2(14);

PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN

    begin
        if    substr(i_gubun,1,1) in ('A','P','C','R','V') then
              v_gubun := substr(i_gubun,1,1) || to_char(sysdate,'YYMM') ;

        elsif substr(i_gubun,1,1) = 'M' then
            v_gubun := substr(i_gubun,1,5) ;

        elsif substr(i_gubun,1,1) = 'B' then
            v_gubun := substr(i_gubun,1,1) ;

        elsif substr(i_gubun,1,1) in ('G') then
              v_gubun := substr(i_gubun,1,2) || to_char(sysdate,'YYMMDD') ;

        elsif substr(i_gubun,1,1) = ('H') then
              v_gubun := substr(i_gubun,1,1) || to_char(sysdate,'YYYY') ;

        elsif substr(i_gubun,1,1) = ('I') then
              v_gubun := substr(i_gubun,1,1) || to_char(sysdate,'YYYYMM') ;

        elsif substr(i_gubun,1,1) = ('J') then
              v_gubun := substr(i_gubun,1,1) || to_char(sysdate,'YY') ;

        elsif substr(i_gubun,1,1) = ('W') then
              v_gubun := substr(i_gubun,1,1) || SUBSTR(i_date, 3);

        elsif substr(i_gubun,1,1) = ('Z') then
              v_gubun := to_char(sysdate,'YYYY') ;

        else
            v_gubun :=substr(i_gubun,1,5) ;
        end if;


        select KEY_SEQ+1
          into v_seq
          from TBZZ0001
         where KEY_GUBUN = v_gubun for update;

        exception when no_data_found then
                  v_seq := 1;
    end;

    if    v_seq = 1 then
          insert into TBZZ0001(KEY_GUBUN,KEY_SEQ) values(v_gubun,v_seq);
    else
          update TBZZ0001 set KEY_SEQ = v_seq where KEY_GUBUN = v_gubun;
    end if;

    commit;

    if    substr(i_gubun,1,1) in ('A','P','C') then   /* 가입/증권/계약 번호 */
              if    to_char(sysdate,'yyyymmdd') > '20130600' then
                    r_seq := i_gubun || to_char(sysdate,'YYMM') || lpad(v_seq,5,'0') || '0' ;
              else
                    r_seq := i_gubun || to_char(sysdate,'YYMM') || lpad(v_seq,6,'0') ;
              end if;

    elsif substr(i_gubun,1,1) = 'R' then   /* 영수 번호 */
          r_seq := i_gubun || to_char(sysdate,'YYMM') || lpad(v_seq,6,'0') ;

    elsif substr(i_gubun,1,1) = 'M' then                 /* 고객번호(보유자코드)-조합 */
          r_seq := v_gubun || lpad(v_seq,4,'0') ;

    elsif substr(i_gubun,1,1) = 'B' then                /* 고객번호(보유자코드)-고객 */
          r_seq := v_gubun || lpad(v_seq,8,'0') ;

    elsif substr(i_gubun,1,1) = 'G' then                /* 보상접수번호  */
          if    substr(i_gubun,2,1) = '2' then
            --일일자차 계약일 경우,
                r_seq := to_char(sysdate,'YYMMDD') || substr(i_gubun,1,1) || lpad(v_seq,3,'0') ;
          else
                r_seq := to_char(sysdate,'YYMMDD') || lpad(v_seq,4,'0') ;
          end if;

    elsif substr(i_gubun,1,1) = 'H' then                /* 소송번호  */
          r_seq := to_char(sysdate,'YYYY')     || lpad(v_seq,4,'0') ;

    elsif substr(i_gubun,1,1) = 'I' then                /* 구상번호  */
          r_seq := to_char(sysdate,'YYYYMM')   || lpad(v_seq,3,'0') ;

    elsif substr(i_gubun,1,1) = 'J' then                /* 민원번호  */
          r_seq := to_char(sysdate,'YYMM')     || lpad(v_seq,5,'0') ;

    elsif substr(i_gubun,1,1) = 'V' then                /* PG한도관리번호  */
          r_seq := i_gubun || to_char(sysdate,'YYMM')     || lpad(v_seq,2,'0') ;

  elsif substr(i_gubun,1,1) = 'W' then                /* 결재번호 */
          r_seq := i_gubun || i_date || lpad(v_seq, 5, '0');

  elsif substr(i_gubun,1,1) = 'Z' then                /* 출자금납입영수증  */
          r_seq := to_char(sysdate,'YYYY')  ||'-' || lpad(v_seq,4,'0') ;

    else
          r_seq := v_gubun || lpad(v_seq,6,'0') ;
    end if;

    return ( r_seq );
END;

CREATE -- added during DDL generation.
FUNCTION FN_GET_SPLIT(i_string IN VARCHAR2,
                                        i_level IN INT,
                                        i_delimeter IN VARCHAR2) RETURN VARCHAR2
/****************************************************************************/
/* Function 명  : 문자열 SPLIT 기능                                         */
/* Parameter    : [ IN] i_string     Split할 전체 문자열                    */
/*                [ IN] i_level      Split할 문자열의 위치                  */
/*                [ IN] i_delimeter  Split기준 구분자 문자열                */
/* Description  : 문자열에 있는 특정 문자 기준으로 Split을 하고 특정 위치값 */
/*               (i_level)을 반환한다.                                      */
/* Example      : i_string = ABC|DEF|GHI|JK,  i_level=2, i_delimeter=| 이면 */
/*                DEF 문자열을 반환한다.                                    */
/* HISTORY      : Creation 2014/04/28 LeeYongHan  카메라모드에서 인식된     */
/*                                                차량번호 통계를 위해 생성 */
/****************************************************************************/
IS
v_return          varchar2(200);               --반환할 문자열
v_strvalue        varchar2(1000) := i_string;  --Split할 전체 문자열
v_idx             int;
v_level           int := 0;

BEGIN
    v_return := '';

    if length(ltrim(rtrim(v_strvalue))) = 0 then
       return '';
    end if;

    loop
       v_idx := instr(v_strvalue, i_delimeter);
       if v_idx > 0 then
          v_level := v_level + 1;

          -- 해당 반환 위치와 동일하면 해당 문자열을 반환한다.
          if v_level = i_level then
             v_return := substr(v_strvalue, 1, v_idx-1);
             exit;
          end if;

          --찾은 문자열을 제외한 문자열을 다시 만든다.
          v_strvalue := substr(v_strvalue, v_idx + length(i_delimeter));
       else
          --찾고자 구분자가 없을 경우 레벨이 1이면 입력한 전체 문자열을 반환하고 아니면 빈문자열을 반환한다.
          if v_level = 0 then
             if i_level = 1 then
                v_return := v_strvalue;
             else
                v_return := '';
             end if;
          else
             v_level := v_level + 1;
             if v_level = i_level then
                v_return := v_strvalue;
             else
                v_return := '';
             end if;
          end if;
          exit;
       end if;
   end loop;

    RETURN v_return;
    exception when others then RETURN sqlerrm;

END;

CREATE or replace -- added during DDL generation.
FUNCTION          FN_GET_USERNAME (i_userid VARCHAR2) RETURN VARCHAR2 deterministic result_cache  AS
r_username     VARCHAR2(50);
s_length       NUMBER;
/********************************************************/
-- i_userid     ('S000001')      사용자ID
-- i_userid     ('M11100001')    고객ID
/********************************************************/
BEGIN
    s_length := length(i_userid);
    if    s_length = 9 then
          begin
                select  CUST_NM
                  into  r_username
                  from  TBAA0001
                 where  CUST_NO = i_userid
                   and  ROWNUM  = 1;
                EXCEPTION WHEN NO_DATA_FOUND THEN  r_username := i_userid;
         end;
    else
          begin
                select  USER_NM
                  into  r_username
                  from  TBZZ0201
                 where  USERID     = i_userid
                   and  LAST_YN    = 'Y'
                   and  ROWNUM = 1;
                EXCEPTION WHEN NO_DATA_FOUND THEN  r_username := i_userid;
         end;

    end if;

return (r_username);
END;
CREATE -- added during DDL generation.
FUNCTION FN_HOLIDAY_CHECK( in_date IN VARCHAR2 )
    RETURN VARCHAR2 AS
/***************************************************************************/
/* Function 명  : 입력한 날짜가 공휴일인지 체크하는 함수                   */
/* Parameter    : [ In] 입력날짜                                           */
/* Return Value : 공휴일 여부(Y, M)                                        */
/* Caeate Date  : 2013-06-01                                               */
/* Caeator      : J.H CHOI                                                 */
/* Description  :                                                          */
/***************************************************************************/
    cunt_day      date;
    holiday_cnt   number(1);
    RETURN_VALUE  varchar2(1) := 'N';

BEGIN
    cunt_day      := to_date(in_date, 'yyyymmdd');

    if to_char(cunt_day, 'd') = '7' or to_char(cunt_day, 'd') = '1' then        --1:토요일, 7:일요일
        RETURN_VALUE := 'Y';
    else

       select count(*)
         into holiday_cnt
         from TBZZ1005        --공휴일정보테이블
        where HOLIDAY_DATE = to_char(cunt_day, 'yyyymmdd');

        if    holiday_cnt = 1 then
              RETURN_VALUE := 'Y';
        else
              RETURN_VALUE := 'N';
        end if;

    end if;

    RETURN (RETURN_VALUE);

    exception when others then
        RETURN ('');

END;
CREATE -- added during DDL generation.
FUNCTION FN_LUNAR_TO_SOLAR( as_lunar IN CHAR )
    RETURN VARCHAR2 IS
/***************************************************************************/
/* Function 명  : 음력을 양력으로 변경하는 함수                            */
/*                1921 - 2030 년 까지의 음력->양력으로 변환하는 함수       */
/* Parameter    : [ In] 음력날짜  (CHAR형)                                 */
/* Return Value : 양력날짜 (CHAR형), Error 발생시 Null Value               */
/* Caeate Date  : 2013-06-01                                               */
/* Caeator      : J.H CHOI                                                 */
/* Description  :                                                          */
/***************************************************************************/
        Out_Of_Range                   exception;
        ls_return                      VARCHAR2(100);
        LunerY                         NUMBER(5) := 0;
        LunerM                         NUMBER(5) := 0;
        LunerD                         NUMBER(5) := 0;
        i                              NUMBER(5) := 0;
        j                              NUMBER(5) := 0;

        -- 1921년부터 해당년까지의 년수
        ll_FromYear                    NUMBER(10) := 0;
        ls_YunMon                      VARCHAR2(500);     --윤달
        ls_YunLen                      VARCHAR2(500);     --윤달의 길이(29 OR 30)

        --매년 정상적인 달의 길이의 합
        --( 12 byte의 자리값 * (30일인 경우만 1 ) 의 합)
        ls_MonLen                      VARCHAR2(500);
        ls_lYearDay                    VARCHAR2(500);     --음력으로 윤달의 길이(29 OR 30)
        ls_SolarMon                    VARCHAR2(39);

        --0000-00-00부터 해당일자까지의 누적일수
        ll_DaySum                      NUMBER(10);

        li_M NUMBER(5) := 0 ;
        MM NUMBER(5) := 0 ;
        MK NUMBER(5):=0 ;

        v_loop NUMBER(5) :=0;

        li_PrevYear NUMBER(5):=0;
        li_OneYearDay  NUMBER(5):=0;
        NA NUMBER(5):=0;
        YD NUMBER(5):=0;
        KA NUMBER(5):=0;
        SolarY NUMBER(5):=0 ;
        SolarM NUMBER(5):=0 ;
        SolarD NUMBER(5):=0;
BEGIN
    LunerY := TO_NUMBER(SUBSTR( as_lunar,1,4)) + 2333;
    LunerM := TO_NUMBER(SUBSTR( as_lunar,5,2));
    LunerD := TO_NUMBER(SUBSTR( as_lunar,7,2));

    -- 1921-2030년 범위, 1-12월 범위, 1-31일 범위를 벗어날 경우 에러처리.
    IF (SUBSTR(as_lunar,1,4) < '1921' OR SUBSTR(as_lunar,1,4) > '2030')
       OR
       (SUBSTR(as_lunar,5,2) < '01' OR SUBSTR(as_lunar,5,2) > '12')
       OR
       (SUBSTR(as_lunar,7,2) < '01' OR SUBSTR(as_lunar,7,2) > '31')
       THEN
       raise Out_Of_Range;
    END IF ;

    --1921 - 2030
    ls_YunMon := ' 0 5 0 0 4 0 0 2 0 6'||
                 ' 0 0 5 0 0 3 0 7 0 0'||
                 ' 6 0 0 4 0 0 2 0 7 0'||
                 ' 0 5 0 0 3 0 8 0 0 6'||
                 ' 0 0 4 0 0 3 0 7 0 0'||
                 ' 5 0 0 4 0 8 0 0 6 0'||
                 ' 0 4 010 0 0 6 0 0 5'||
                 ' 0 0 3 0 8 0 0 5 0 0'||
                 ' 4 0 0 2 0 7 0 0 5 0'||
                 ' 0 3 0 9 0 0 5 0 0 4'||
                 ' 0 0 2 0 6 0 0 5 0 0';
    --1921 - 2030
    ls_YunLen := ' 029 0 029 0 029 029'||
                 ' 0 030 0 030 030 0 0'||
                 '30 0 030 0 029 029 0'||
                 ' 030 0 030 029 0 029'||
                 ' 0 029 0 029 029 0 0'||
                 '29 0 029 029 0 030 0'||
                 ' 029 029 0 029 0 029'||
                 ' 0 029 029 0 029 0 0'||
                 '29 0 029 029 0 029 0'||
                 ' 030 029 0 029 0 029'||
                 ' 0 029 029 0 029 0 0';

    --1921 - 2030
    ls_lYearDay := ' 354 384 354 354 385 354 355 384 354 383'||
                   ' 354 355 384 355 354 384 354 384 354 354'||
                   ' 384 355 355 384 354 354 384 354 384 354'||
                   ' 355 384 355 354 384 354 384 354 354 384'||
                   ' 355 354 384 355 353 384 355 384 354 355'||
                   ' 384 354 354 384 354 384 354 355 384 355'||
                   ' 354 384 354 384 354 354 385 354 355 384'||
                   ' 354 354 383 355 384 355 354 384 354 354'||
                   ' 384 354 355 384 355 384 354 354 384 354'||
                   ' 354 384 355 384 355 354 384 354 354 384'||
                   ' 354 355 384 354 384 355 354 383 355 354';

    --1921 - 2030
    ls_MonLen := '26352891170527722997 6942395133511751622'||
                 '3658374917051461 69422222350321332213402'||
                 '346629211389 603 60523493371270934132890'||
                 '290113651243 603213513232715168517062794'||
                 '2741120627342647131838783477171713862477'||
                 '1245119826383405336534132900343423942395'||
                 '1179271526352855170117482901 69423951207'||
                 '117516111866374917531453 694241423503222'||
                 '37333402349318771389 699 605234932432709'||
                 '28902890290113731211 6032391132327092965'||
                 '1706277317171206267026471319170234751450';

    ll_DaySum := 701303  ; --1920년까지의 누적일수

    --1921년무터 해당일자 직전 년도 까지의 년수 계산
    ll_FromYear := LunerY - 4254  ;
    FOR  i IN 1..ll_FromYear LOOP
        ll_DaySum := ll_DaySum + TO_NUMBER( SubStr( ls_lYearDay, i*4-3, 4 ) );
    END LOOP;

    --해당년도의 월 계산
    IF LunerM <> 1  THEN --1월이 아닐 경우에만 월->일로 환산
        li_M := 2048;
        ll_FromYear := ll_FromYear + 1;

        MM := TO_NUMBER( SUBSTR( ls_MonLen, ll_FromYear*4-3,4 ) );

        FOR  j IN 1..LunerM - 1 LOOP
            --해당월의 일수를 누적시켜나간다.
            ll_DaySum := ll_DaySum + 29 + TRUNC(MM / li_M);

            MM := MM - TRUNC(MM / li_M) * li_M;
            li_M := TRUNC(li_M / 2);

            IF  j = TO_NUMBER( SUBSTR( ls_YunMon,ll_FromYear*2-1,2 ) )  THEN
                --윤달일 경우
                ll_DaySum := ll_DaySum +
                    TO_NUMBER( SUBSTR( ls_YunLen, ll_FromYear*2-1,2 ) );
            END IF;
        END LOOP ;
    END IF;

    -- 해당월의 일 누적
    ll_DaySum := ll_DaySum + LunerD;

    ------------------------------------------------------
    --1921년부터 해당일 까지의 누적일수를 계산하여 더한다.
    ------------------------------------------------------
    li_PrevYear := TRUNC(ll_DaySum/365) - 1    ;
    NA := TRUNC(ll_DaySum - li_PrevYear*365)    ;
    YD := TRUNC(li_PrevYear/4) - TRUNC(li_PrevYear/100) + TRUNC(li_PrevYear/400) ;
    KA := NA - YD  ;

    IF KA < 0 THEN
        li_PrevYear := li_PrevYear - 1;
        NA := ll_DaySum - TRUNC(li_PrevYear*365);
        YD := TRUNC(li_PrevYear/4) - TRUNC(li_PrevYear/100 ) + TRUNC(li_PrevYear/400);
        NA := NA - YD;
    ELSE
        NA := KA;
    END IF;

    --양력으로 해당년도의 일수를 계산한다.
    SolarY := li_PrevYear + 1;
    IF   SolarY = TRUNC(SolarY/4)*4  AND  SolarY<>TRUNC(SolarY/100)*100 THEN
        ls_SolarMon := '  0 31 29 31 30 31 30 31 31 30 31 30 31';
        li_OneYearDay := 366;
    ELSIF  SolarY = TRUNC(SolarY/400)*400 THEN
        ls_SolarMon := '  0 31 29 31 30 31 30 31 31 30 31 30 31';
        li_OneYearDay := 366;
    ELSE
        ls_SolarMon := '  0 31 28 31 30 31 30 31 31 30 31 30 31';
        li_OneYearDay := 365;
    END IF;

    IF NA = 0 THEN
        NA := li_OneYearDay;
        SolarY := SolarY - 1;
    END IF;

    FOR  I IN 1..13 LOOP
        v_loop := I;
        IF  NA > TO_NUMBER( SUBSTR( ls_SolarMon,I*3-2,3 ) ) THEN
            NA := NA - TO_NUMBER( SUBSTR( ls_SolarMon,I*3-2,3 ) );
        ELSE
            EXIT;
        END IF;
    END LOOP;

    SolarM := v_loop - 1;
    SolarD := NA;
    ls_return := LPAD(SolarY,4,'0') ||
                 LPAD(SolarM,2,'0') ||
                 LPAD(SolarD,2,'0');
    Return ls_return;

    exception
        WHEN DUP_VAL_ON_INDEX then
            ls_return := 'DUP_VAL_ON_INDEX 입니다.';
            Return ls_return;
        WHEN INVALID_NUMBER then
            ls_return := 'INVALID_NUMBER 입니다.';
            Return ls_return;
        WHEN LOGIN_DENIED then
            ls_return := 'Login Denied.';
            Return ls_return;
        WHEN NOT_LOGGED_ON then
            ls_return := 'Not Logged On.';
            Return ls_return;
        WHEN PROGRAM_ERROR then
            ls_return := 'Program Error입니다.';
            Return ls_return;
        WHEN STORAGE_ERROR then
            ls_return := 'Storage Error입니다.';
            Return ls_return;
        WHEN TIMEOUT_ON_RESOURCE then
            ls_return := 'Timeout on resource.';
            Return ls_return;
        WHEN VALUE_ERROR then
            ls_return := 'VALUE_ERROR 입니다. ';
            Return ls_return;
        WHEN ZERO_DIVIDE then
            ls_return := 'Zero Divide .';
            Return ls_return;
        WHEN Out_Of_Range then
            ls_return := '범위(1921.01.01-2030.11.28)를 벗어났습니다.';
            Return ls_return;
        WHEN others then
            ls_return := SUBSTR(SQLERRM, 1, 100 );
            Return ls_return;
END;
CREATE -- added during DDL generation.
FUNCTION          FN_NUM2HAN(n_number NUMBER)
RETURN VARCHAR2 AS
    n_unit   NUMBER;
    n_length NUMBER;
    v_prev   VARCHAR2(8);
    v_digit  VARCHAR2(8);
    v_number VARCHAR2(150);
    v_return VARCHAR2(150);
BEGIN
    -- [ Usage ]
    -- SELECT FN_NUM2HAN(125670000           ) FROM DUAL; -- 일억이천오백육십칠만
    -- SELECT FN_NUM2HAN(100000000           ) FROM DUAL; -- 1억
    -- SELECT FN_NUM2HAN(1000000000000       ) FROM DUAL; -- 1조
    -- SELECT FN_NUM2HAN(1000000000000000    ) FROM DUAL; -- 1000조
    -- SELECT FN_NUM2HAN(10000000000000000000) FROM DUAL; -- 1000경
    IF n_number = 0 AND n_number < 0 THEN
        RETURN '영';
    END IF;
    n_unit   := 0;
    v_number := LTRIM(TO_CHAR(n_number,'99999999999999999999'));  -- 천경
    n_length := LENGTH(v_number);
    v_digit  := NULL;
    FOR i IN 1 .. n_length LOOP
        v_prev  := v_digit;
        v_digit := SUBSTR(v_number, n_length-i+1, 1);
        IF v_digit = '1' THEN v_digit := '일'; END IF;
        IF v_digit = '2' THEN v_digit := '이'; END IF;
        IF v_digit = '3' THEN v_digit := '삼'; END IF;
        IF v_digit = '4' THEN v_digit := '사'; END IF;
        IF v_digit = '5' THEN v_digit := '오'; END IF;
        IF v_digit = '6' THEN v_digit := '육'; END IF;
        IF v_digit = '7' THEN v_digit := '칠'; END IF;
        IF v_digit = '8' THEN v_digit := '팔'; END IF;
        IF v_digit = '9' THEN v_digit := '구'; END IF;
        IF v_digit = '1' THEN v_digit := '일'; END IF;
        IF v_digit = '0' THEN v_digit := NULL; END IF;
        -- DBMS_OUTPUT.PUT_LINE(' DIGIT : [' || v_digit || ']');
        -- DBMS_OUTPUT.PUT_LINE(' DEBUG : [' || i || '/' || i || ']');
        IF v_digit IS NOT NULL THEN
            IF MOD(i, 4) = 2 THEN
                v_digit := v_digit || '십';
            END IF;
            IF MOD(i, 4) = 3 THEN
                v_digit := v_digit || '백';
            END IF;
            IF MOD(i, 4) = 0 THEN
                v_digit := v_digit || '천';
            END IF;
        END IF;
        IF (v_digit IS NOT NULL AND i = 5) OR  --
           (v_digit IS NOT NULL AND v_prev IS NULL AND i > 5 AND i<9) THEN
            v_digit := v_digit || '만';
        END IF;
        IF (v_digit IS NOT NULL AND i = 9) OR
           (v_digit IS NOT NULL AND v_prev IS NULL AND i > 9 AND i<13) THEN
            v_digit := v_digit || '억';
        END IF;
        IF (v_digit IS NOT NULL AND i =13) OR
           (v_digit IS NOT NULL AND v_prev IS NULL AND i >13 AND i<17) THEN
            v_digit := v_digit || '조';
        END IF;
        IF (v_digit IS NOT NULL AND i =17) OR
           (v_digit IS NOT NULL AND v_prev IS NULL AND i >17 AND i<21) THEN
            v_digit := v_digit || '경';
        END IF;
        IF v_digit IS NOT NULL THEN
            v_return := v_digit || v_return;
        END IF;
        IF MOD(i,4) = 4 THEN
            n_unit := n_unit + 1;
        END IF;
    END LOOP;

    --v_return := '일금 ' || v_return || '원정'
    --DBMS_OUTPUT.PUT_LINE('[' || v_return || ']');
    RETURN '일금 ' || v_return || '원정';
EXCEPTION
    WHEN OTHERS THEN v_return := SQLCODE;
    RETURN v_return;
END;
CREATE -- added during DDL generation.
function FN_RENT_BUNAP_AMT (i_na_mth              in varchar2
                                                     , i_i_kind_cd           in varchar2
                                                     , i_spcl_agre_gb        in varchar2
                                                     , i_bnp_cnt             in number
                                                     , i_dmbo_appy_prem      in number
                                                     , i_dmbo_basic_prem     in number
                                                     , i_istar_cont_date     in date
                                                     , i_sort_gubun          in varchar2
                                                   ) return varchar2 as
/**********************************************************************************************/
/* Function 명  : 배서 분할금 Select Function                                                **/
/* Parameter           : [ In] i_na_mth              납입방법                                **/
/*                       [ In] i_i_kind_cd           상품종류                                **/
/*                       [ In] i_spcl_agre_gb        '0'                                     **/
/*                       [ In] i_bnp_cnt             분납횟수                                **/
/*                       [ In] i_dmbo_appy_prem      적용보험료                              **/
/*                       [ In] i_dmbo_basic_prem     기본보험료                              **/
/*                       [ In] i_istar_cont_date     보험시기                                **/
/*                       [ In] i_sort_gubun          Sort 구분                               **/
/*                       [Out] V_CONCAT_BUNHAL                                               **/
/*                             납입횟수,분납일자,분납유효일자,기준보험료,적용보험료          **/
/* Description  :  기본보험료와 적용보험를 분납율에 따라 Select 하여 구분자(,)붙여 Retrun    **/
/**********************************************************************************************/


V_SUM_APPY_PREM         number;
V_SUM_BASIC_PREM        number;
V_CONCAT_BUNHAL         varchar2(4000);

BEGIN

    if    i_sort_gubun = 'DESC' then
          select nvl(sum(round(i_dmbo_basic_prem * (DVDPAY_RATE / 100),-1)),0)
               , nvl(sum(round(i_dmbo_appy_prem  * (DVDPAY_RATE / 100),-1)),0)
            into V_SUM_BASIC_PREM
               , V_SUM_APPY_PREM
            from TBIB0205 A1
           where BUNAP_GB     = to_char(to_number(i_na_mth))
             and DVDPAY_GB    = to_char(i_bnp_cnt)
             and I_KIND_CD    = i_i_kind_cd
             and SPCL_AGRE_GB = i_spcl_agre_gb
             and APLY_FYMD   <= i_istar_cont_date
             and APLY_EYMD   >= i_istar_cont_date
             and NABIB_CNT    > 1 ;

           select LISTAGG(NABIB_CNT || '|' || NABIB_FROM_DATE || '|' || NABIB_TO_DATE || '|' || NABIB_AMT1 || '|' || NABIB_AMT2, ',' ) WITHIN GROUP(ORDER BY NABIB_CNT DESC)
             into V_CONCAT_BUNHAL
             from(select *
                    from (select NABIB_CNT            -- 납입횟차
                               , i_dmbo_basic_prem -  V_SUM_BASIC_PREM    as NABIB_AMT1     -- 1회차 기준분담금
                               , i_dmbo_appy_prem  -  V_SUM_APPY_PREM     as NABIB_AMT2     -- 1회차 적용분담금
                               , add_months(i_istar_cont_date , NABIB_MM) as NABIB_FROM_DATE
                               , add_months(i_istar_cont_date , VALID_MM) as NABIB_TO_DATE
                            FROM TBIB0205
                           where BUNAP_GB     = to_char(to_number(i_na_mth))
                             and DVDPAY_GB    = to_char(i_bnp_cnt)
                             and I_KIND_CD    = i_i_kind_cd
                             AND SPCL_AGRE_GB = i_spcl_agre_gb
                             and APLY_FYMD   <= i_istar_cont_date
                             and APLY_EYMD   >= i_istar_cont_date
                             AND NABIB_CNT    = 1
                            UNION ALL
                           select NABIB_CNT            -- 납입횟차
                               , round(i_dmbo_basic_prem * (DVDPAY_RATE / 100),-1)  as NABIB_AMT1     -- 1회차 이후 기준분담금
                               , round(i_dmbo_appy_prem  * (DVDPAY_RATE / 100),-1)  as NABIB_AMT2    -- 1회차 이후 적용분담금
                               , add_months(i_istar_cont_date , NABIB_MM)           as NABIB_FROM_DATE
                               , add_months(i_istar_cont_date , VALID_MM )          as NABIB_TO_DATE
                            FROM TBIB0205
                           where BUNAP_GB     = to_char(to_number(i_na_mth))
                             and DVDPAY_GB    = to_char(i_bnp_cnt)
                             and I_KIND_CD    = i_i_kind_cd
                             AND SPCL_AGRE_GB = i_spcl_agre_gb
                             and APLY_FYMD   <= i_istar_cont_date
                             and APLY_EYMD   >= i_istar_cont_date
                             AND NABIB_CNT    > 1
                         )
                    order by  NABIB_CNT desc
                   ) ;
    else
          select nvl(sum(round(i_dmbo_basic_prem * (DVDPAY_RATE / 100),-1)),0)
               , nvl(sum(round(i_dmbo_appy_prem  * (DVDPAY_RATE / 100),-1)),0)
            into V_SUM_BASIC_PREM
               , V_SUM_APPY_PREM
            from TBIB0205 A1
           where BUNAP_GB     = to_char(to_number(i_na_mth))
             and DVDPAY_GB    = to_char(i_bnp_cnt)
             and I_KIND_CD    = i_i_kind_cd
             and SPCL_AGRE_GB = i_spcl_agre_gb
             and APLY_FYMD   <= i_istar_cont_date
             and APLY_EYMD   >= i_istar_cont_date
             and NABIB_CNT    > 1 ;

           select LISTAGG(NABIB_CNT || '|' || NABIB_FROM_DATE || '|' || NABIB_TO_DATE || '|' || NABIB_AMT1 || '|' || NABIB_AMT2, ',') WITHIN GROUP(ORDER BY NABIB_CNT asc)
             into V_CONCAT_BUNHAL
             from(select *
                    from (select NABIB_CNT            -- 납입횟차
                               , i_dmbo_basic_prem -  V_SUM_BASIC_PREM    as NABIB_AMT1     -- 1회차 기준분담금
                               , i_dmbo_appy_prem  -  V_SUM_APPY_PREM     as NABIB_AMT2     -- 1회차 적용분담금
                               , add_months(i_istar_cont_date , NABIB_MM) as NABIB_FROM_DATE
                               , add_months(i_istar_cont_date , VALID_MM) as NABIB_TO_DATE
                            FROM TBIB0205
                           where BUNAP_GB     = to_char(to_number(i_na_mth))
                             and DVDPAY_GB    = to_char(i_bnp_cnt)
                             and I_KIND_CD    = i_i_kind_cd
                             AND SPCL_AGRE_GB = i_spcl_agre_gb
                             and APLY_FYMD   <= i_istar_cont_date
                             and APLY_EYMD   >= i_istar_cont_date
                             AND NABIB_CNT    = 1
                            UNION ALL
                           select NABIB_CNT            -- 납입횟차
                               , round(i_dmbo_basic_prem * (DVDPAY_RATE / 100),-1)  as NABIB_AMT1     -- 1회차 이후 기준분담금
                               , round(i_dmbo_appy_prem  * (DVDPAY_RATE / 100),-1)  as NABIB_AMT2    -- 1회차 이후 적용분담금
                               , add_months(i_istar_cont_date , NABIB_MM)           as NABIB_FROM_DATE
                               , add_months(i_istar_cont_date , VALID_MM )          as NABIB_TO_DATE
                            FROM TBIB0205
                           where BUNAP_GB     = to_char(to_number(i_na_mth))
                             and DVDPAY_GB    = to_char(i_bnp_cnt)
                             and I_KIND_CD    = i_i_kind_cd
                             AND SPCL_AGRE_GB = i_spcl_agre_gb
                             and APLY_FYMD   <= i_istar_cont_date
                             and APLY_EYMD   >= i_istar_cont_date
                             AND NABIB_CNT    > 1
                         )
                    order by  NABIB_CNT asc
                   ) ;
    end if;

    return ( V_CONCAT_BUNHAL );

    exception when others
              then dbms_output.put_line('FN_RENT_BUNAP_AMT Main Error: '||sqlerrm);
                   raise_application_error(-20001, 'FN_RENT_BUNAP_AMT Error: '||sqlerrm);

END;
CREATE -- added during DDL generation.
function FN_RENT_C_PART_CAR_AMT(i_job_gubun  in varchar2
                                                  , i_enter_no   in varchar2
                                                  , i_endor_no   in varchar2
                                                  , i_work_date  in varchar2 ) return number as
/**********************************************************************************************/
/* Function 명  : 일부공제요율  FN_RENT_C_PART_CAR_AMT                                       **/
/* Parameter           : [ In] i_job_gubun          배서('2'  )                              **/
/*                       [ In] i_enter_no           가입설계번호/증권번호                    **/
/*                       [ In] i_endor_no           배서번호                                 **/
/*                       [ In] i_work_date          소급배서일                               **/
/* Description  :                                                                            **/
/*  1. 새차요율 또는 중고차요율 * (1 + (공제가액  / 공제계약금액)) * 0.5                     **/
/**********************************************************************************************/

V_MOTOR_VALUE             number :=0;                                /* 차량가액                          */
V_ATTACH_VALUE            number :=0;                                /* 부속품 가액                       */
V_CAR_UNIT_GAEK           TBIB0001.CAR_UNIT_GAEK%TYPE := 0;          /* [IN] 기계장치총가액               */

V_MOTOR_AMT               number :=0;                                /* 차량가입금액                      */
V_ATTACH_AMT              number :=0;                                /* 부속품 가입금액                   */
V_CAR_UNIT_AMT            TBIB0001.CAR_UNIT_AMT%TYPE  := 0;          /* [IN] 기계장치 가입금액            */

V_MOTOR_APPL_AMT          number :=0;                                /* (차량가입금액+부속품 가액)보정금액*/
BEGIN

    if    i_job_gubun = '2' then
          begin
              select nvl(sum(MLGUN_AMT)   , 0)
                   , nvl(sum(MLGUN_ENT_AMT),0)
                into V_ATTACH_VALUE
                   , V_ATTACH_AMT
                from TBID0011T
               where POL_NO     = i_enter_no
                 and ENDOR_NO   = i_endor_no
                 and WORK_DATE  = to_date(i_work_date, 'YYYYMMDD')
                 and INS_AIM_GB = '1';

               exception when no_data_found then V_ATTACH_VALUE := 0;
                                                 V_ATTACH_AMT   := 0;
                         when others        then raise_application_error(-20013, 'Fn_endor_car_part_amt TBID011T Error: '||sqlerrm);
          end;

          begin
              select nvl(CAR_GAEK    , 0)
                   , nvl(CAR_AMT     , 0)
                   , nvl(CAR_UNIT_GAEK,0)
                   , nvl(CAR_UNIT_AMT ,0)
                into V_MOTOR_VALUE
                   , V_MOTOR_AMT
                   , V_CAR_UNIT_GAEK
                   , V_CAR_UNIT_AMT
                from TBID0001T
               where POL_NO    = i_enter_no
                 and ENDOR_NO  = i_endor_no
                 and WORK_DATE = to_date(i_work_date, 'YYYYMMDD');

               exception when no_data_found then raise_application_error(-20013, 'Fn_endor_car_part_amt TBID0001T Error: '||sqlerrm);
                         when others         then raise_application_error(-20013, 'Fn_endor_car_part_amt TBID0001T Error: '||sqlerrm);
          end;

    end if;

    /************************************************************************************************************************************************/
    /* 일부공제요율계산은 신차와 무관하게 (1+(공제가액/공제가입금액)) * 1/2)로 계산해야 함 *20130405 박순덕과장과 협의 후 아래와 같이 수정함(이용한)*/
    /* if    V_MOTOR_AMT = V_MOTOR_VALUE then   -- 신차일때                                                                                         */
    /*       V_MOTOR_APPL_AMT := 1;                                                                                                                 */
    /* else                                                                                                                                         */
    /*       V_MOTOR_APPL_AMT := ( 1 +  (V_MOTOR_VALUE + V_ATTACH_VALUE + V_CAR_UNIT_GAEK)                                                          */
    /*                                   / (V_MOTOR_AMT   + V_ATTACH_AMT   + V_CAR_UNIT_AMT )                                                       */
    /*                          ) * (1/2) ;                                                                                                         */
    /* end if;                                                                                                                                      */
    /************************************************************************************************************************************************/

    V_MOTOR_APPL_AMT  := ( 1 +  (V_MOTOR_VALUE + V_ATTACH_VALUE + V_CAR_UNIT_GAEK)
                              / (V_MOTOR_AMT   + V_ATTACH_AMT   + V_CAR_UNIT_AMT )
                         ) * (1/2) ;


    return V_MOTOR_APPL_AMT;

    exception when no_data_found    then return -1;
              when dup_val_on_index then return -2;
              when others           then return  0;

end;
CREATE -- added during DDL generation.
function FN_RENT_C_VIP_CAR_RATE(i_job_gubun     in varchar2
                                                  , i_enter_no      in varchar2
                                                  , i_endor_no      in number
                                                  , i_work_date     in varchar2) return number as
/**********************************************************************************************/
/* Function 명  : 고가차량 특별요율 산정                                                     **/
/* Parameter           : [ In] i_job_gubun          가입설계('1') ,배서('2')                 **/
/*                       [ In] i_enter_no           가입설계번호/증권번호                    **/
/*                       [ In] i_endor_no           배서번호                                 **/
/*                       [ In] i_work_date          소급배서일                               **/
/* Description  :                                                                            **/
/*  1. 5천만원 <= 차량가액 <= 7천5백만원                                                     **/
/*     적용율 = 1 + ((피보험자차량가액 - 5천만원) / (7천5백만원-5천만원) * 0.04              **/
/*                                                                                           **/
/*  2. 7천5백만원 < 차량가액 <=1억5천만원                                                    **/
/*     적용율 = 1 + ((피보험자차량가액 - 7천5백만원) / (1억5천만원-7천5백만원) * 0.12 + 0.04 **/
/*                                                                                           **/
/*  3. 1억5천만원 < 차량가액 <=  2억5천만원 :                                                **/
/*     적용율 = 1 + ((피보험자차량가액 - 1억5천만원) / (2억5천만원-1억5천만원) * 0.17 + 0.16 **/
/*                                                                                           **/
/*  4. 2억5천만원 < 차량가액 <= 4억원 :                                                      **/
/*     적용율 = 1 + ((피보험자차량가액 - 2억5천만원) / (4억만원-2억5천만원) * 0.30 + 0.33    **/
/*                                                                                           **/
/*  5. 4억원      < 차량가액 <= 7억5천만원 :                                                 **/
/*     적용율 = 1 + ((피보험자차량가액 - 7억5천만원) / (7억5천만원-4억만원) * 1.-2 + 0.63    **/
/*                                                                                           **/
/*  6. 7억5천만원 < 차량가액 :                                                               **/
/*    적용율 = 265%                                                                          **/
/**********************************************************************************************/

V_MOTOR_VALUE             number :=0;          -- 차량가액
V_VIP_APPL_AMT            number :=100;        -- 고가차량 특별요율

BEGIN
    if    i_job_gubun = '2' then
          begin
                select NVL(CAR_GAEK + CAR_ACC_GAEK + CAR_UNIT_GAEK,0)
                  into V_MOTOR_VALUE
                  from TBID0001T
                 where POL_NO    = i_enter_no
                   and ENDOR_NO  = i_endor_no
                   and WORK_DATE = to_date(i_work_date, 'YYYYMMDD');

                exception when no_data_found then V_VIP_APPL_AMT := -1;
                          when others        then raise_application_error(-20013, 'FN_RENT_C_VIP_CAR_RATE TBID0001T Error: '||sqlerrm);
          end;


    end if;

    if    V_MOTOR_VALUE between 50000000 and 75000000 then
          V_VIP_APPL_AMT := (1 + ( (V_MOTOR_VALUE -  50000000) / ( 75000000  -  50000000)) * 0.04) * 100;

    elsif V_MOTOR_VALUE   > 75000000   and  V_MOTOR_VALUE <= 150000000  then
          V_VIP_APPL_AMT := (1 + ( (V_MOTOR_VALUE -  75000000) / (150000000  -  75000000)) * 0.12 + 0.04) * 100;

    elsif V_MOTOR_VALUE   > 150000000  and  V_MOTOR_VALUE <= 250000000  then
          V_VIP_APPL_AMT := (1 + ( (V_MOTOR_VALUE - 150000000) / (250000000  - 150000000)) * 0.17 + 0.16) * 100;

    elsif V_MOTOR_VALUE   > 250000000  and  V_MOTOR_VALUE <= 400000000  then
          V_VIP_APPL_AMT := (1 + ( (V_MOTOR_VALUE - 250000000) / (400000000  - 250000000)) * 0.3  + 0.33) * 100;

    elsif V_MOTOR_VALUE   > 400000000  and  V_MOTOR_VALUE <= 750000000  then
          V_VIP_APPL_AMT := (1 + ( (V_MOTOR_VALUE - 400000000) / (750000000  - 400000000)) * 1.02 + 0.63) * 100;

    elsif V_MOTOR_VALUE   > 750000000  then
          V_VIP_APPL_AMT := 265;

    elsif V_VIP_APPL_AMT <> -1 then
          V_VIP_APPL_AMT := 100;
    end if;

    return V_VIP_APPL_AMT;

    exception when no_data_found    then return -1;
              when dup_val_on_index then return -2;
              when others           then return 0;
END;
CREATE -- added during DDL generation.
function FN_RENT_MUL_ACCI_RATE( i_dambo_cd             varchar2
                                                , i_mul_acci_cd          varchar2
                                                , i_istar_cont_date      date ) return number as
/***************************************************************************/
/* Function 명  : 물적할증율 구하기                                        */
/* Parameter    : [ In] i_dambo_cd           담보코드                      */
/*                [ In] i_mul_acci_cd        물적할증코드                  */
/*                [ In] i_istar_cont_date    보험시기                      */
/*                [Out] o_mul_acci_rate                                    */
/* Description  : 물적 할증율 Return                                       */
/***************************************************************************/
o_mul_acci_rate    number(5,2);

BEGIN
      if i_mul_acci_cd is null then
            return 0;
      else
            select APLY_RATE
              into o_mul_acci_rate
              from TBIB0207
             where DAMBO_CD    = i_dambo_cd
               and GUBUN       = '4'
               and AP_PREM_CD = i_mul_acci_cd
               and i_istar_cont_date between APLY_FYMD and APLY_EYMD;
      end if;

      return o_mul_acci_rate;

exception when no_data_found    then  return -1;
          when dup_val_on_index then  return -2;
          when others           then  return 0;
END;
CREATE -- added during DDL generation.
function FN_RENT_OLD_CAR_RATE( i_car_kind_cd          TBIB0001.CAR_KIND_CD%TYPE
                                          , i_car_pass_year        TBIB0001.CAR_PASS_YEAR%TYPE
                                          , i_istar_cont_date      date ) return number as
/***************************************************************************/
/* Function 명  : 중고차율율 구하기                                        */
/* Parameter    : [ In] i_car_kind_cd          차종                        */
/*                [ In] i_car_pass_year        경과년수                    */
/*                [ In] i_istar_cont_date      보험시기                    */
/*                [Out] o_old_car_rate                                     */
/* Description  : 중고차율 Return                                          */
/***************************************************************************/
s_car_y_diff       number := i_car_pass_year;
o_old_car_rate     number;
BEGIN

     if    s_car_y_diff <= 0  then
           s_car_y_diff := 1;
     elsif s_car_y_diff >= 12 then
           s_car_y_diff := 12;
     end if;

     select MOTOR_OLD_RATE
       into o_old_car_rate
       from TBIB0211
      where MOTOR_KIND   = i_car_kind_cd
        and OLD_YEAR_CNT = s_car_y_diff
        and i_istar_cont_date between APPL_SDATE and APPL_EDATE;

     return o_old_car_rate;

exception when no_data_found    then return -1;
          when dup_val_on_index then return -2;
          when others           then return 0;
END;
CREATE -- added during DDL generation.
function FN_RENT_PART_CAR_AMT(i_job_gubun  in varchar2
                                                  , i_enter_no   in varchar2
                                                  , i_endor_no   in varchar2 ) return number as
/**********************************************************************************************/
/* Function 명  : 일부공제요율  FN_RENT_PART_CAR_AMT                                         **/
/* Parameter           : [ In] i_job_gubun          가입설계('1') ,배서('2'  )               **/
/*                       [ In] i_enter_no           가입설계번호/증권번호                    **/
/*                       [ In] i_endor_no           배서번호                                 **/
/* Description  :                                                                            **/
/*  1. 새차요율 또는 중고차요율 * (1 + (공제가액  / 공제계약금액)) * 0.5                     **/
/**********************************************************************************************/

V_MOTOR_VALUE             number :=0;                                /* 차량가액                          */
V_ATTACH_VALUE            number :=0;                                /* 부속품 가액                       */
V_CAR_UNIT_GAEK           TBIB0001.CAR_UNIT_GAEK%TYPE := 0;          /* [IN] 기계장치총가액               */

V_MOTOR_AMT               number :=0;                                /* 차량가입금액                      */
V_ATTACH_AMT              number :=0;                                /* 부속품 가입금액                   */
V_CAR_UNIT_AMT            TBIB0001.CAR_UNIT_AMT%TYPE  := 0;          /* [IN] 기계장치 가입금액            */

V_MOTOR_APPL_AMT          number :=0;                                /* (차량가입금액+부속품 가액)보정금액*/
BEGIN

    if    i_job_gubun = 1 then
          /***********************************************************************************************/
          /*  INS_AIM_GB = '1' 조건이 빠지면 부속품과 장치가 모두 SUM이 되어 아래 장치SUM과 중복됨  ******/
          /*  따라서 INS_AIM_GB = '1' 조건을 추가해서 부속품만 SUM이 되도록 수정하였음 20130405 (이용한) */
          /***********************************************************************************************/
          begin
               select nvl(sum(MLGUN_AMT)    ,0)
                    , nvl(sum(MLGUN_ENT_AMT),0)
                 into V_ATTACH_VALUE
                    , V_ATTACH_AMT
                 from TBIB0011
                where ENT_DGN_NO = i_enter_no
                  and INS_AIM_GB = '1';


                exception when no_data_found
                               then V_ATTACH_VALUE := 0;
                                    V_ATTACH_AMT   := 0;
                          when others
                               then raise_application_error(-20013, 'Fn_car_part_amt TBIB0011(부속품) Error: '||sqlerrm);
          end;

          begin
               select nvl(CAR_GAEK     ,0)
                    , nvl(CAR_AMT      ,0)
                    , nvl(CAR_UNIT_GAEK,0)
                    , nvl(CAR_UNIT_AMT ,0)
                 into V_MOTOR_VALUE
                    , V_MOTOR_AMT
                    , V_CAR_UNIT_GAEK
                    , V_CAR_UNIT_AMT
                 from TBIB0001
                where ENT_DGN_NO = i_enter_no;

                exception when no_data_found
                               then raise_application_error(-20013, 'Fn_car_part_amt TBIB0001 Error: '||sqlerrm);
                          when others
                               then raise_application_error(-20013, 'Fn_car_part_amt TBIB0001 Error: '||sqlerrm);
          end;

    else
          begin
              select nvl(sum(MLGUN_AMT)   , 0)
                   , nvl(sum(MLGUN_ENT_AMT),0)
                into V_ATTACH_VALUE
                   , V_ATTACH_AMT
                from TBID0011
               where POL_NO   = i_enter_no
                 and ENDOR_NO = i_endor_no
                 and INS_AIM_GB = '1';

               exception when no_data_found then V_ATTACH_VALUE := 0;
                                                 V_ATTACH_AMT   := 0;
                         when others        then raise_application_error(-20013, 'Fn_endor_car_part_amt TBID011 Error: '||sqlerrm);
          end;

          begin
              select nvl(CAR_GAEK    , 0)
                   , nvl(CAR_AMT     , 0)
                   , nvl(CAR_UNIT_GAEK,0)
                   , nvl(CAR_UNIT_AMT ,0)
                into V_MOTOR_VALUE
                   , V_MOTOR_AMT
                   , V_CAR_UNIT_GAEK
                   , V_CAR_UNIT_AMT
                from TBID0001
               where POL_NO   = i_enter_no
                 and ENDOR_NO = i_endor_no;

               exception when no_data_found then raise_application_error(-20013, 'Fn_endor_car_part_amt TBID0001 Error: '||sqlerrm);
                         when others         then raise_application_error(-20013, 'Fn_endor_car_part_amt TBID0001 Error: '||sqlerrm);
          end;

    end if;

    /************************************************************************************************************************************************/
    /* 일부공제요율계산은 신차와 무관하게 (1+(공제가액/공제가입금액)) * 1/2)로 계산해야 함 *20130405 박순덕과장과 협의 후 아래와 같이 수정함(이용한)*/
    /* if    V_MOTOR_AMT = V_MOTOR_VALUE then   -- 신차일때                                                                                         */
    /*       V_MOTOR_APPL_AMT := 1;                                                                                                                 */
    /* else                                                                                                                                         */
    /*       V_MOTOR_APPL_AMT := ( 1 +  (V_MOTOR_VALUE + V_ATTACH_VALUE + V_CAR_UNIT_GAEK)                                                          */
    /*                                   / (V_MOTOR_AMT   + V_ATTACH_AMT   + V_CAR_UNIT_AMT )                                                       */
    /*                          ) * (1/2) ;                                                                                                         */
    /* end if;                                                                                                                                      */
    /************************************************************************************************************************************************/

    V_MOTOR_APPL_AMT  := ( 1 +  (V_MOTOR_VALUE + V_ATTACH_VALUE + V_CAR_UNIT_GAEK)
                              / (V_MOTOR_AMT   + V_ATTACH_AMT   + V_CAR_UNIT_AMT )
                         ) * (1/2) ;


    return V_MOTOR_APPL_AMT;

    exception when no_data_found    then return -1;
              when dup_val_on_index then return -2;
              when others           then return  0;

end;
CREATE -- added during DDL generation.
function FN_RENT_SHORT_RATE( i_i_kind_cd             varchar2
                                                 , i_basis_from            date
                                                 , i_basis_to              date
                                                 , i_istar_cont_date       date
                                                 , i_iend_cont_date        date ) return number as
/*********************************************************************/
/* StoredProcedure 명  : FN_RENT_SHORT_RATE                          */
/* Parameter           : [ In] i_i_kind_cd          보험(공제)종목   */
/*                       [ In] i_basis_from         적용시작일       */
/*                       [ In] i_basis_to           적용종료일       */
/*                       [ In] i_istar_cont_date    보험시기         */
/*                       [ In] i_iend_cont_date     보험종기         */
/* Description  :   단기률  산출 Function 산출                       */
/*********************************************************************/
/* 공제기간  1~3일 4~5일  6~7일  8~15일  15~1월  2월  3월  4월  5월 **/
/* 단기요율    3%     5%     6%     10%     15%  20%  30%  40%  50% **/
/*------------------------------------------------------------------**/
/* 공제기간   6월   7월    8월     9월    10월  11월  12월          **/
/* 단기요율   60%   70%    80%     85%    90%    95%  100%          **/
/*********************************************************************/

V_SHT_RATE          TBIB0208.SHT_RATE%TYPE;
s_gubun             varchar2(1);
s_mm                number;
s_end_last_day      varchar2(3);
s_start_last_day    varchar2(3);
s_add_month         number;

BEGIN
     /*****************************************************************/
     /* trunc(months_between(i_basis_to-1, i_basis_from)              */
     /* 종료일에서 시작일을 빼서  일수를 계산 한다                    */
     /* EX) '2013-02-10' - '2013-03-10' 일 경우 2개월로 계산이 되어서 */
     /*      종료일에서 하루를 빼서 계산을 한다                       */
     /*****************************************************************/

      /****************************************************************/
     /* 시기: 1.28 ~ 1.30 일 까지는 한달후 종기가 2.28로 계산         */
     /* 시기: 2.28일  한달후 종기는 3.28 3.29 3.30,3.31일이 해당됨    */
     /*****************************************************************/
     s_end_last_day    := to_char(last_day(i_basis_to) ,'dd');
     s_start_last_day  := to_char(last_day(i_basis_from),'dd');

     if    s_end_last_day   = to_char(i_basis_to  ,'dd') and s_end_last_day    < to_char(i_basis_from ,'dd') then
           s_add_month     := 1;
     elsif s_start_last_day = to_char(i_basis_from ,'dd') and s_start_last_day  < to_char(i_basis_to  ,'dd')   then
           s_add_month     := 0;
     else
           s_add_month     := 1;
     end if;

     if    i_basis_to - i_basis_from between 1 and 15 then
           s_gubun := 1;
           s_mm    := 0;
     elsif i_basis_to - i_basis_from > 15 then
           s_gubun := 2;
           if    trunc(months_between(i_basis_to-1, i_basis_from), 0) + s_add_month > 12 then
                 s_mm := 12;
           else
                 s_mm := trunc(months_between(i_basis_to-1, i_basis_from), 0) + s_add_month;
           end if;
     end if;

     /* 일수로계산 하여 단기요율 계산 *******/
     if    s_gubun = 1 then
           begin
                 select SHT_RATE
                   into V_SHT_RATE
                   from TBIB0208
                  where I_KIND_CD = i_i_kind_cd
                    and TERM_UNIT = '1'
                    and (i_basis_to - i_basis_from) between INS_TERM_DN and INS_TERM_UP
                    and APLY_FYMD <= i_basis_from
                    and APLY_EYMD >= i_basis_from;

                 exception when no_data_found then  V_SHT_RATE := -1;
                           when others        then  V_SHT_RATE := 0;
           end;
     else  /* 월수로 로계산 하여 단기요율 계산 *******/
           begin
                 select SHT_RATE
                   into V_SHT_RATE
                   from TBIB0208
                  where I_KIND_CD   = i_i_kind_cd
                    and TERM_UNIT   = '2'
                    and s_mm        between INS_TERM_DN and INS_TERM_UP
                    and APLY_FYMD  <= i_basis_from
                    and APLY_EYMD  >= i_basis_from;

                 exception when no_data_found then V_SHT_RATE := -1;
                           when others        then V_SHT_RATE := 0;
            end;
     end if;

     return V_SHT_RATE;

     exception when no_data_found    then  return -1;
               when dup_val_on_index then  return -2;
               when others           then  return 0;
END;
CREATE OR REPLACE -- added during DDL generation.
function FN_RENT_USE_CAR_AMT(i_cont_start_date  in varchar2
                                                  , i_car_reg_date   in varchar2
                                                  , i_new_car_amt   in varchar2
                                                  , i_useful_life   in varchar2 ) return number as
/**********************************************************************************************/
/* Function 명  :  FN_RENT_USE_CAR_AMT(잔존가액 가져오기)                                    **/
/* Parameter           : [ In] i_cont_start_date    공제시기                                 **/
/*                       [ In] i_car_reg_date       차량등록일자                             **/
/*                       [ In] i_new_car_amt        신차가액                                 **/
/* Description  :                                                                            **/
/**********************************************************************************************/

V_MOTOR_APPL_AMT          number :=0;                                /* 환산금액*/
V_CAR_RATE                number :=0;

BEGIN

    select RATE
     into V_CAR_RATE
      from tbcz0016
     where 1=1
       and last_yn = 'Y'
       and useful_life = i_useful_life
       and pass_month = floor(months_between(TO_CHAR(TO_DATE(i_cont_start_date),'YYYYMMDD'),TO_CHAR(TO_DATE(i_car_reg_date),'YYYYMMDD')))
     ;


    V_MOTOR_APPL_AMT  :=  FLOOR((i_new_car_amt * V_CAR_RATE)/10000)*10000;


    return V_MOTOR_APPL_AMT;

    exception when no_data_found    then return -1;
              when dup_val_on_index then return -2;
              when others           then return  0;

end;
CREATE -- added during DDL generation.
function FN_RENT_VIP_CAR_RATE(i_job_gubun     in varchar2
                                                  , i_enter_no      in varchar2
                                                  , i_endor_no      in number ) return number as
/**********************************************************************************************/
/* Function 명  : 고가차량 특별요율 산정                                                     **/
/* Parameter           : [ In] i_job_gubun          가입설계('1') ,배서('2')                 **/
/*                       [ In] i_enter_no           가입설계번호/증권번호                    **/
/*                       [ In] i_endor_no           배서번호                                 **/
/* Description  :                                                                            **/
/*  1. 5천만원 <= 차량가액 <= 7천5백만원                                                     **/
/*     적용율 = 1 + ((피보험자차량가액 - 5천만원) / (7천5백만원-5천만원) * 0.04              **/
/*                                                                                           **/
/*  2. 7천5백만원 < 차량가액 <=1억5천만원                                                    **/
/*     적용율 = 1 + ((피보험자차량가액 - 7천5백만원) / (1억5천만원-7천5백만원) * 0.12 + 0.04 **/
/*                                                                                           **/
/*  3. 1억5천만원 < 차량가액 <=  2억5천만원 :                                                **/
/*     적용율 = 1 + ((피보험자차량가액 - 1억5천만원) / (2억5천만원-1억5천만원) * 0.17 + 0.16 **/
/*                                                                                           **/
/*  4. 2억5천만원 < 차량가액 <= 4억원 :                                                      **/
/*     적용율 = 1 + ((피보험자차량가액 - 2억5천만원) / (4억만원-2억5천만원) * 0.30 + 0.33    **/
/*                                                                                           **/
/*  5. 4억원      < 차량가액 <= 7억5천만원 :                                                 **/
/*     적용율 = 1 + ((피보험자차량가액 - 7억5천만원) / (7억5천만원-4억만원) * 1.-2 + 0.63    **/
/*                                                                                           **/
/*  6. 7억5천만원 < 차량가액 :                                                               **/
/*    적용율 = 265%                                                                          **/
/**********************************************************************************************/

V_MOTOR_VALUE             number :=0;          -- 차량가액
V_VIP_APPL_AMT            number :=100;        -- 고가차량 특별요율

BEGIN
    if    i_job_gubun = '1' then
          begin
                /********************************************************************************************************/
                /* 고가차량 차량가액 기준은 총차량가액 기준이어야 함(기존 차량가액으로 된 부분을 총차량가액으로 수정함) */
                /* 20130405 박순덕과장과 공유한 후 수정함(이용한)                                                       */
                /********************************************************************************************************/
                select  NVL(CAR_GAEK + CAR_ACC_GAEK + CAR_UNIT_GAEK,0)
                  into  V_MOTOR_VALUE
                  from  TBIB0001
                 where  ent_dgn_no = i_enter_no;

                 exception when no_data_found then V_VIP_APPL_AMT := -1;
                           when others        then raise_application_error(-20013, 'Fn_car_part_amt 차량가액이 없습니다... '||sqlerrm);
          end;
    else
          begin
                select NVL(CAR_GAEK + CAR_ACC_GAEK + CAR_UNIT_GAEK,0)
                  into V_MOTOR_VALUE
                  from TBID0001
                 where POL_NO   = i_enter_no
                   and ENDOR_NO = i_endor_no;

                exception when no_data_found then V_VIP_APPL_AMT := -1;
                          when others        then raise_application_error(-20013, 'Fn_car_part_amt TBID0001 Error: '||sqlerrm);
          end;


    end if;

    if    V_MOTOR_VALUE between 50000000 and 75000000 then
          V_VIP_APPL_AMT := (1 + ( (V_MOTOR_VALUE -  50000000) / ( 75000000  -  50000000)) * 0.04) * 100;

    elsif V_MOTOR_VALUE   > 75000000   and  V_MOTOR_VALUE <= 150000000  then
          V_VIP_APPL_AMT := (1 + ( (V_MOTOR_VALUE -  75000000) / (150000000  -  75000000)) * 0.12 + 0.04) * 100;

    elsif V_MOTOR_VALUE   > 150000000  and  V_MOTOR_VALUE <= 250000000  then
          V_VIP_APPL_AMT := (1 + ( (V_MOTOR_VALUE - 150000000) / (250000000  - 150000000)) * 0.17 + 0.16) * 100;

    elsif V_MOTOR_VALUE   > 250000000  and  V_MOTOR_VALUE <= 400000000  then
          V_VIP_APPL_AMT := (1 + ( (V_MOTOR_VALUE - 250000000) / (400000000  - 250000000)) * 0.3  + 0.33) * 100;

    elsif V_MOTOR_VALUE   > 400000000  and  V_MOTOR_VALUE <= 750000000  then
          V_VIP_APPL_AMT := (1 + ( (V_MOTOR_VALUE - 400000000) / (750000000  - 400000000)) * 1.02 + 0.63) * 100;

    elsif V_MOTOR_VALUE   > 750000000  then
          V_VIP_APPL_AMT := 265;

    elsif V_VIP_APPL_AMT <> -1 then
          V_VIP_APPL_AMT := 100;
    end if;

    return V_VIP_APPL_AMT;

    exception when no_data_found    then return -1;
              when dup_val_on_index then return -2;
              when others           then return 0;
END;
CREATE -- added during DDL generation.
FUNCTION FN_GET_BUSS_DAY( in_date IN VARCHAR2 ) RETURN VARCHAR2 AS

/**************************************************************************************************************
PROJECT NAME  : 한국렌트카공제조합
DBMS          : Oracle11g
DATABASE      : KRCA
INPUT PARAM   :
OUT PARAM     : r_seq = 그달의 실효일자 찾기
              :
DESCRIPTION   : 시스템의 현재달의 실효일자를 돌려준다.
ETC           :
**************************************************************************************************************
Modification Information
Date          Developer           Content
-------       -------------       ---------------------------
2013.06.04    은현민           CREATE
----------------------------------------------------------------------------------------------------
* Copyright (C) 2013 by MPC Corp. All rights reserved.
**************************************************************************************************************/
v_job_date       date;
hollyday_yn      varchar2(2) ;
r_return_date    varchar2(8);

idx1             number      :=0;

BEGIN

    if     in_date is null or in_date = '' then
           v_job_date := to_date(to_char(sysdate, 'yyyymm') || '01', 'yyyymmdd') - 1;
    else
           v_job_date := to_date(substr(in_date,1,6) || '01', 'yyyymmdd') - 1;
    end if ;

    SELECT FN_HOLIDAY_CHECK(TO_CHAR(v_job_date, 'yyyymmdd'))
           INTO hollyday_yn
           FROM dual;

    if     hollyday_yn = 'N' then
           r_return_date  :=   to_char(v_job_date + 1,'yyyymmdd');
    else
           v_job_date     :=   v_job_date + 1;
           loop
                 if    idx1 > 15 then
                       r_return_date  :=   '19990101';
                       exit;
                 end if;

                 SELECT FN_HOLIDAY_CHECK(TO_CHAR(v_job_date, 'yyyymmdd'))
                 INTO hollyday_yn
                 FROM dual;

                 if     hollyday_yn = 'N' then
                        r_return_date  :=   to_char(v_job_date + 1,'yyyymmdd');
                        exit;
                 else
                        v_job_date     :=   v_job_date + 1;
                 end if;
                 idx1  := idx1 + 1;
           end loop;
    end if;


    RETURN (r_return_date);
    exception when others then RETURN ('19990101');

END;
CREATE -- added during DDL generation.
FUNCTION          FN_GET_BUSS_DAY_CHECK( in_date IN VARCHAR2 ) RETURN VARCHAR2 AS

/**************************************************************************************************************
PROJECT NAME  : 한국렌트카공제조합
DBMS          : Oracle11g
DATABASE      : KRCA
INPUT PARAM   :
OUT PARAM     : RETURN_VALUE = 6,16,26, 기준 영업일 여부
DESCRIPTION   : 영업일 여부 체크
ETC           :
**************************************************************************************************************
Modification Information
Date          Developer           Content
-------       -------------       ---------------------------
2013.08.28    강신규           CREATE
----------------------------------------------------------------------------------------------------
* Copyright (C) 2013 by MPC Corp. All rights reserved.
**************************************************************************************************************/
v_dd             varchar2(2) := substr(in_date,7,2);
v_last_dd        varchar2(2) := substr(to_char(last_day(to_date(in_date,'yyyymmdd')),'yyyymmdd'),7,2);
v_gijun_date     date;
v_from_date      date;
v_to_date        date;
v_job_date       date;

idx1             number      :=0;
hollyday_yn      varchar2(2) ;
return_value     varchar2(1) ;

BEGIN
    if    v_dd >= '01' and  v_dd <= '10'      then
          v_gijun_date  :=  to_date(substr(in_date,1,6) || '06','yyyymmdd');
          v_job_date    :=  v_gijun_date;
          v_from_date   :=  to_date(substr(in_date,1,6) || '01','yyyymmdd');
          v_to_date     :=  to_date(substr(in_date,1,6) || '10','yyyymmdd');
    elsif v_dd >= '11' and  v_dd <= '20'      then
          v_gijun_date  :=  to_date(substr(in_date,1,6) || '16','yyyymmdd');
          v_job_date    :=  v_gijun_date;
          v_from_date   :=  to_date(substr(in_date,1,6) || '11','yyyymmdd');
          v_to_date     :=  to_date(substr(in_date,1,6) || '20','yyyymmdd');
    elsif v_dd >= '21' and  v_dd <= v_last_dd then
          v_gijun_date  :=  to_date(substr(in_date,1,6) || '26','yyyymmdd');
          v_job_date    :=  v_gijun_date;
          v_from_date   :=  to_date(substr(in_date,1,6) || '21','yyyymmdd');
          v_to_date     :=  to_date(substr(in_date,1,6) || v_last_dd,'yyyymmdd');
    else
          idx1  := 100;
    end if;

    Loop
         if    idx1 > 15 then
               return_value :='N';
               exit;
         end if;

         SELECT FN_HOLIDAY_CHECK(TO_CHAR(v_job_date, 'yyyymmdd'))
           INTO hollyday_yn
           FROM dual;

         if    hollyday_yn = 'N' then
               return_value :='Y';
               exit;
         end if;

         if    v_job_date  >=  v_to_date then
               v_job_date  := v_gijun_date - 1;
         elsif v_job_date  <  v_gijun_date then
               v_job_date  := v_job_date - 1;
         else
               v_job_date  := v_job_date + 1;
         end if;

         if    v_job_date < v_from_date then
               return_value :='N';
               exit;
         end if;

        idx1   := idx1 + 1;

    End Loop;

    if    return_value = 'Y' then
          if   to_char(v_job_date, 'yyyymmdd') = in_date then
               return_value := 'Y';
          else
               return_value := 'N';
          end if;
    end if;

    RETURN (return_value);
    exception when others then RETURN ('N');

END;
CREATE -- added during DDL generation.
FUNCTION          FN_GET_CANC_SCHEDULE_DATE(r_date IN DATE)
RETURN DATE
IS
v_date    date;
rt_date   date;
/******************************************************************************
   NAME:       FN_GET_CANC_SCHEDULE_DATE
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        2016-01-15          1. Created this function.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     FN_GET_CANC_SCHEDULE_DATE
      Sysdate:         2016-01-15
      Date and Time:   2016-01-15, 오전 9:54:10, and 2016-01-15 오전 9:54:10
      Username:         (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
BEGIN
    if     r_date is null or r_date = '' then
           v_date := sysdate;
    else
           v_date := r_date;
    end if ;

    SELECT LAS_DATE
    INTO rt_date
    FROM (
        WITH LAPSED_DAYS AS(
            -- 1. 기간에 해당하는 분납일 익월 말일 날짜 가져옴.
            SELECT LAST_DAY(ADD_MONTHS(v_date,1)) AS  LAPSED_DAY
            FROM DUAL
        )
        SELECT TO_DATE(TO_CHAR(MIN(las_date), 'YYYYMMDD') || '235959', 'YYYYMMDDHH24MISS')  AS LAS_DATE
        FROM (
            -- 2. 1에서 가져온 날짜로 영업일 세팅
            SELECT (LAPSED_DAY + LEVEL -1 ) AS las_date
            , FN_HOLIDAY_CHECK(TO_CHAR((LAPSED_DAY + LEVEL-1), 'YYYYMMDD')) AS HOLI_YN
            FROM ( SELECT LAPSED_DAY FROM LAPSED_DAYS)
            CONNECT BY (LAPSED_DAY + LEVEL -1) <= ADD_MONTHS(LAPSED_DAY,1)
        ) B
        WHERE B.HOLI_YN = 'N'
        GROUP BY HOLI_YN
    );
    RETURN (rt_date);

END;
CREATE -- added during DDL generation.
FUNCTION          FN_GET_HND_COVER (i_accidentNo VARCHAR2)
RETURN VARCHAR2 AS r_hndCover     VARCHAR2(300);
BEGIN
    begin

   SELECT
       REPLACE(A.VAL, ',', '/')
       || CASE WHEN B.VAL IS NOT NULL THEN
           '/' || REPLACE(B.VAL, ',', '/')
       END AS HND_COVER INTO r_hndCover -- 담보명
   FROM
        (
         WITH COVER AS
           (
               SELECT FN_GET_CODENAME1('C0001', HND_COVER) HND_COVER
                 FROM TBCC0001
                WHERE ACCIDENT_NO = i_accidentNo
                  AND LAST ='Y'
                  ORDER BY DMGE_NO
           )
         SELECT WM_CONCAT(HND_COVER) AS VAL FROM COVER
        ) A,
        (
         WITH COVER AS
           (
               SELECT FN_GET_CODENAME1('C0001', HND_COVER) HND_COVER
                 FROM TBCD0001
                WHERE ACCIDENT_NO = i_accidentNo
                  AND LAST ='Y'
                  ORDER BY DMGE_NO
           )
         SELECT WM_CONCAT(HND_COVER) AS VAL FROM COVER
        ) B;

        EXCEPTION WHEN NO_DATA_FOUND THEN
            r_hndCover := i_accidentNo;
    end;
return (r_hndCover );
END;
CREATE -- added during DDL generation.
FUNCTION          FN_GET_HND_COVER_GROUP (i_accidentNo VARCHAR2)
RETURN VARCHAR2 AS r_hndCover     VARCHAR2(100);
BEGIN
    begin

   SELECT
       REPLACE(A.VAL, ',', '/')
       || CASE WHEN B.VAL IS NOT NULL THEN
           '/' || REPLACE(B.VAL, ',', '/')
       END AS HND_COVER INTO r_hndCover -- 담보명
   FROM
        (
         WITH COVER AS
           (
               SELECT FN_GET_CODENAME1('C0001', HND_COVER) HND_COVER
                 FROM TBCC0001
                WHERE ACCIDENT_NO = i_accidentNo
                  AND LAST ='Y'
                GROUP BY HND_COVER
           )
         SELECT WM_CONCAT(HND_COVER) AS VAL FROM COVER
        ) A,
        (
         WITH COVER AS
           (
               SELECT FN_GET_CODENAME1('C0001', HND_COVER) HND_COVER
                 FROM TBCD0001
                WHERE ACCIDENT_NO = i_accidentNo
                  AND LAST ='Y'
                GROUP BY HND_COVER
           )
         SELECT WM_CONCAT(HND_COVER) AS VAL FROM COVER
        ) B;

        EXCEPTION WHEN NO_DATA_FOUND THEN
            r_hndCover := i_accidentNo;
    end;
return (r_hndCover );
END;
CREATE -- added during DDL generation.
FUNCTION FN_GET_NEXTDAY(in_from_date IN VARCHAR2, in_dist IN VARCHAR2, in_day IN NUMBER) RETURN VARCHAR2 AS

/**************************************************************************************************************
PROJECT NAME  : 한국렌트카공제조합
DBMS          : Oracle11g
DATABASE      : KRMA
INPUT PARAM   : [in_from_date] : 시작일(YYYYMMDD)
                [in_dist]      : 업무일유무 1: 업무일(휴일제외)  2:모든일자
                [in_day]       : 경과일
DESCRIPTION   : from_date로부터 경과일의 일자를 리턴한다.(YYYYMMDD)
**************************************************************************************************************
Modification Information
Date          Developer               Content
-------       -------------           ---------------------------
2013.10.02    이준희                  CREATE
----------------------------------------------------------------------------------------------------
* Copyright (C) 2013 by MPC Corp. All rights reserved.
**************************************************************************************************************/

v_in_day       NUMBER;
v_holiday_yn   VARCHAR2(1);         --공휴일여부체크
v_updown_yn    VARCHAR2(1);         --일자를 증가하면서 체크할지 감소하면서 체크할지 구분(Y:증가, N:감소) -> in_day가 양수이면 중가, 음수이면 감소)
r_from_date    VARCHAR2(8);         --날짜가계산된반환값(YYYYMMDD)

BEGIN
  --양수일기준으로 증가할지 음수일 기준으로 감소할지 체크
  if (in_day > 0) then v_updown_yn := 'Y'; else v_updown_yn := 'N'; end if;


  if in_dist = '2' then
     SELECT to_char(to_date(in_from_date, 'yyyymmdd') + in_day,'yyyymmdd') INTO r_from_date FROM DUAL;
  else
    r_from_date := in_from_date;
    v_in_day := in_day;
    LOOP
      if(v_in_day = 0)then
          exit;
      else
          if(v_updown_yn = 'Y') then
             r_from_date := to_char((to_date(r_from_date, 'yyyymmdd')+1), 'yyyymmdd');
          else
             r_from_date := to_char((to_date(r_from_date, 'yyyymmdd')-1), 'yyyymmdd');
          end if;

          SELECT FN_HOLIDAY_CHECK(r_from_date)
            INTO v_holiday_yn
            FROM DUAL;

          if v_holiday_yn = 'N' then
            if(v_updown_yn = 'Y') then
               v_in_day := v_in_day - 1;    --0으로 수렴하기 위해 감소시킴
            else
               v_in_day := v_in_day + 1;    --0으로 수렴하기 위해 증가심킴
            end if;
          end if;

      end if;

    END LOOP;





  end if;

  RETURN (r_from_date);

EXCEPTION when others then
  RETURN ('');
END;

