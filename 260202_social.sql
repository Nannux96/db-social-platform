--1
SELECT username, AGE(birthdate)
FROM users

--2
SELECT p.id
FROM posts p
LEFT JOIN likes l ON p.id=l.post_id
WHERE l.created_at IS NULL

--3
SELECT p.id, COUNT(*) as like_count
FROM posts p
LEFT JOIN likes l ON p.id=l.post_id
GROUP BY p.id

--4
SELECT username,  COUNT(*) as mediaNumber
FROM users u
LEFT JOIN medias m ON u.id=m.user_id
GROUP BY u.id
ORDER BY COUNT(*) DESC

--5
SELECT username,  COUNT(*) as mediaNumber
FROM users u
LEFT JOIN posts p ON u.id=p.user_id
LEFT JOIN likes l ON p.id=l.post_id
GROUP BY u.id
ORDER BY COUNT(*) DESC

--6
SELECT p.id
FROM posts p
WHERE p.user_id IN
(
	SELECT id FROM users
	WHERE EXTRACT(YEAR FROM AGE(birthdate)) BETWEEN 20 AND 30
)

--7
WITH postPerUser AS (
SELECT user_id, count(*) as postCount
FROM posts
GROUP BY user_id
), mediaPerUser AS (
SELECT user_id, COUNT(*) as mediaCount
FROM medias
GROUP BY user_id
)

SELECT username, postCount, mediaCount
FROM users u
LEFT JOIN postPerUser p on u.id=p.user_id
LEFT JOIN mediaPerUser m on u.id=m.user_id

--8
SELECT id
FROM posts 
WHERE tags::jsonb ? 'serata';

--9
SELECT id, json_array_length(tags) as tagsCount
FROM posts
ORDER BY tagsNumber DESC;

--10
WITH userTagNumber AS ( 
SELECT user_id, SUM (json_array_length(tags)) as tagsCount
FROM posts
GROUP BY user_id
)
SELECT username, tagsCount
FROM users u
JOIN userTagNumber ut on u.id=ut.user_id
ORDER BY tagsCount DESC;