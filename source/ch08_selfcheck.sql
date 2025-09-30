-- 셀프체크
-- 8장에서 만든 market DB의 상품 중 가격이 낮은 하위 4개의 누적 매출을 다음과 같이 조회하고 싶습니다.
-- 이를 위한 쿼리를 작성하세요.
-- (ch08_09_market_db.png 참고)

-- ----------------------------------
-- 상품명        | 가격     | 누적 매출
-- ----------------------------------
-- 플레인 베이글  | 1300    | 6500
-- 우유 900ml    | 1970    | 9850
-- 크림 치즈      | 2180    | 8720
-- 우유 식빵      | 2900    | 8700

-- 누적 매출은 price * count(가격 * 판매 수량)으로 구합니다.

USE market;

-- 내가한거)
SELECT 
	p.name AS 상품명,
    p.price AS 가격, 
    SUM(p.price * od.count) AS '누적 매출'
FROM products p
JOIN order_details od ON p.id = od.product_id
JOIN orders o ON od.order_id = o.id 
	AND status = '배송 완료'
GROUP BY od.product_id, name -- name으로 묶어도 ㄱㅊ은데, 엄격하게 하는건 od.product_id
ORDER BY p.price ASC -- ASC(오름차순)는 스킵가능
LIMIT 4;

-- 쌤이한거)
SELECT *
FROM products p
JOIN order_details od ON p.id = od.product_id
JOIN orders o ON od.order_id = o.id;


SELECT 
	name AS 상품명,
    price AS 가격,
    SUM(price * count) AS '누적 매출'
FROM products p
JOIN order_details od ON p.id = od.product_id
JOIN orders o ON od.order_id = o.id
WHERE status = '배송 완료'
GROUP BY name, price -- 상품별로 가격은 유일하므로 그룹으로 묶어도 결과에 영향 없음
ORDER BY price
LIMIT 4;
