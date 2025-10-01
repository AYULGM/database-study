-- 셀프체크
-- 8장에서 만든 market DB를 토대로 다음 1~4를 수행하는 쿼리를 작성하세요.
-- (ch08_09_market_db.png 참고)

USE market;

-- 1. 다음은 모든 사용자 수를 세는 쿼리입니다. 
-- 이를 SELECT 절의 서브쿼리로 활용해 전체 사용자의 1인당 평균 결제 금액을 조회하세요.
SELECT COUNT(*)
FROM users;

-- ------------------
-- 1인당 평균 결제 금액
-- ------------------
-- 41790.0000

-- 정답: 
-- 평균 결제 금액 = 전체 결제 금액 / 사용자 수
SELECT SUM(amount) / (SELECT COUNT(*) FROM users) AS '1인당 평균 결제 금액'
FROM payments;

-- 2. 다음은 사용자 아이디별로 총 결제 금액을 집계하는 쿼리입니다.
-- 이를 FROM 절의 서브쿼리로 활용해 전체 사용자의 1인당 평균 결제 금액을 조회하세요.
SELECT u.id AS user_id, SUM(amount) AS total_amount
FROM users u
JOIN orders o ON u.id = o.user_id
JOIN payments p ON o.id = p.order_id
GROUP BY u.id;

-- ------------------
-- 1인당 평균 결제 금액
-- ------------------
-- 41790.0000

-- 정답:
SELECT AVG(sub.total_amount) AS '1인당 평균 결제 금액'
FROM (
	SELECT u.id AS user_id, SUM(amount) AS total_amount
	FROM users u
	JOIN orders o ON u.id = o.user_id
	JOIN payments p ON o.id = p.order_id
	GROUP BY u.id
) sub; -- FROM절 서브쿼리 별칭 필수


-- 3. 앞의 두 문제(1과 2)의 정답 쿼리를 실행하면 다음과 같이 동일한 결과가 나옵니다. 그 이유를 설명하세요.
-- ------------------
-- 1인당 평균 결제 금액
-- ------------------
-- 41790.0000

-- 정답: 모든 사용자가 결제에 참여했기 때문
-- 1은 결제에 참여하지 않은 사람 포함 전체 인원으로 집계, 2는 진짜 결제한 사람만 집계

-- 테스트(결제에 참여안한 사람을 데이터에 넣어보면 이젠 데이터가 다르게나옴)
INSERT INTO users (email, nickname)
VALUES ('geoblo@naver.com', '김재');

SELECT * FROM users;


-- 4. 다음은 최근에 배송받은 사용자의 아이디를 찾는 쿼리입니다.
-- 이를 WHERE 절의 서브쿼리로 활용해 해당 사용자의 총 결제 금액을 조회하세요.
SELECT user_id
FROM orders
WHERE status = '배송 완료'
ORDER BY created_at DESC
LIMIT 1;

-- 정답:
SELECT *
FROM users u
JOIN orders o ON u.id = o.user_id
JOIN payments p ON o.id = p.order_id
WHERE u.id = (
	SELECT user_id
	FROM orders
	WHERE status = '배송 완료'
	ORDER BY created_at DESC
	LIMIT 1
);

-- 닉네임 까지 같이 조회하려면, GROUP BY로 닉네임을 묶어줘야함.
SELECT nickname, SUM(amount)
FROM users u
JOIN orders o ON u.id = o.user_id
JOIN payments p ON o.id = p.order_id
WHERE u.id = (
	SELECT user_id
	FROM orders
	WHERE status = '배송 완료'
	ORDER BY created_at DESC
	LIMIT 1
)
GROUP BY nickname;
