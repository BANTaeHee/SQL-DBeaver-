drop table if exists tb_ord;
create table tb_ord
(
	ord_no char(6) primary key
,	ord_de char(8)
, 	prdt_nm varchar(50)
,	brand_nm varchar(50)
,	ord_amt numeric(15,0)
, 	ord_cnt int
);

insert into tb_ord values ('100001', '20221001', '갤럭시 S22 Ultra', '삼성', 400000,1);
insert into tb_ord values ('100002', '20221002', '갤럭시 S22 Ultra', '삼성', 600000,2);
insert into tb_ord values ('100003', '20221003', '갤럭시 S23 Ultra', '삼성', 800000,4);
insert into tb_ord values ('100004', '20221004', '갤럭시 S23 Ultra', '삼성', 900000,8);

insert into tb_ord values ('100005', '20221005', 'IPhone 14 Pro', '애플', 500000,1);
insert into tb_ord values ('100006', '20221006', 'IPhone 14 Pro', '애플', 700000,2);
insert into tb_ord values ('100007', '20221007', 'IPhone 15 Pro', '애플', 900000,4);
insert into tb_ord values ('100008', '20221008', 'IPhone 15 Pro', '애플', 1000000,8);

select * from tb_ord;

-- GROUP BY :  prdt_nm, brand_nm
select  
		A.prdt_nm
,		A.brand_nm
,		sum(A.ord_amt) as SUM_ORD_AMT
,		sum(A.ord_cnt) as SUM_ORD_CNT
from tb_ord A
group by A.prdt_nm , A.brand_nm
order by A.prdt_nm , A.brand_nm
;

-- GROUP BY : PRDT_NM
-- prdt_nm별 주문금액합계, 주문수량 합계를구함
-- brand_nm의 자리는 null로 대체함

select  A.prdt_nm
,		null as Brand_nm
,		sum(ord_amt) as SUM_ORD_AMT
,		sum(ord_cnt) as SUM_ORD_CNT
from tb_ord A
group by A.prdt_nm , A.brand_nm
order by A.prdt_nm , A.brand_nm
;

-- GROUP BY : BRAND_NM
-- brand_nm별 주문금액합계, 주문수량 합계를 구함
-- prdt_nm 처리는 null로 대체
select  
		null as prdt_nm 
,		a.brand_nm
,		sum(ord_amt) as SUM_ORD_AMT
,		sum(ord_cnt) as SUM_ORD_CNT
from tb_ord A
group by A.prdt_nm , A.brand_nm
order by A.prdt_nm , A.brand_nm
;

-- GROUP BY : 전체 집계
select  
	null as prdt_nm 
,   null as brand_nm 
,   sum(ord_amt) as sum_ord_amt
,   sum(ord_cnt) as sum_ord_cnt
from tb_ord A
;
/*
 * 	- GROUP by + union all 연산
 * 1) prdt_nm + brand_nm별 합계
 * 2) prdt_nm별 합계
 * 3) brand_nm별 합계
 * 4) tb_ord 테이블 전체 합계
 */
select  A.prdt_nm
,		A.brand_nm
,		sum(ord_amt) as SUM_ORD_AMT
,		sum(ord_cnt) as SUM_ORD_CNT
from tb_ord A
group by A.prdt_nm , A.brand_nm
union all
select  A.prdt_nm
,		null as Brand_nm
,		sum(ord_amt) as SUM_ORD_AMT
,		sum(ord_cnt) as SUM_ORD_CNT
from tb_ord A
group by A.prdt_nm , A.brand_nm
union all
select   
	null as prdt_nm 
,   a.brand_nm 
,   sum(ord_amt) as sum_ord_amt
,   sum(ord_cnt) as sum_ord_cnt
from tb_ord A
group by A.prdt_nm , A.brand_nm
union all
select 
    null as prdt_nm 
,   null as brand_nm 
,   sum(ord_amt) as sum_ord_amt
,   sum(ord_cnt) as sum_ord_cnt
from tb_ord A
group by A.prdt_nm , A.brand_nm
order by prdt_nm , brand_nm
;

-- GROUPING SETS()
select A.prdt_nm
	,  A.brand_nm
	,  sum(ord_amt) as SUM_ORD_AMT
	,  sum(ord_cnt) as SUM_ORD_CNT
from tb_ord A
group by
grouping sets (
			(A.prdt_nm, A.brand_nm)
		,	(A.prdt_nm)
		,	(A.brand_nm)
		,	()
)
order by 1,2
;


select * from tb_ord;

--- cube절
/**
 * 	cube(A.prdt_nm, A.brand_nm)
 * 	=>	(A.prdt_nm, A.brand_nm)
 * 		(A.prdt_nm)
 * 		(brand_nm)
 * 		()
 * 	- 총 4개의 그룹화 결과가 출력됨
 * 	- 인자가 2개, 2의 2승
 * 	
 * 	- cube는 다차원 집계를 구함
 * 	- cube에 들어간 인자의 수가 3개이면 2의 3승 = 총 8개의 그룹화 결과가 출렴됨
 */
select A.prdt_nm
	,  A.brand_nm
	,  sum(ord_amt) as SUM_ORD_AMT
	,  sum(ord_cnt) as SUM_ORD_CNT
from tb_ord A
group by cube(A.prdt_nm, A.brand_nm)
order by A.prdt_nm, A.brand_nm
;

------ROLLUP 절 
/*
 * 	- 지정한 컬럼에 대한 계층형으로 여러개의 그룹화 집합을 리턴함.
 * 	- prdt_nm + brand_nm 별 집계 출력
 * 	- prdt_nm별 집계 출력
 * 	- 전체 집계 출력
 * 	- brand_nm별로는 집계를 하지 않음
 * 
 * 	- prdt_nm 컬럼을 기준으로 하향식(계층형)
 */
select A.prdt_nm
	,  A.brand_nm
	,  sum(ord_amt) as SUM_ORD_AMT
	,  sum(ord_cnt) as SUM_ORD_CNT
from tb_ord A
group by rollup (A.prdt_nm, A.brand_nm)
order by A.prdt_nm, A.brand_nm
;




































































