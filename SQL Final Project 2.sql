
--1.1. Hər kursda neçə nəfər qeydiyyatdan keçib?
SELECT COUNT(e.enrollment_id), c.course_name 
FROM [dbo].[Enrollments] AS e
JOIN [dbo].[Courses] AS c
ON e.course_id = c.course_id
GROUP BY c.course_id, c.course_name



--1.2. İstifadəçilərin qeydiyyatdan keçdiyi orta kurs sayı
select AVG(count_of_courses) as average_course_count
from
(select user_id, Count(course_id) as count_of_courses from [dbo].[Enrollments]
group by user_id) as sub

--2.1. Ən aktiv istifadəçilər (enrollment sayına görə)
select max(count_of_enrollment) from 
(select user_id, Count(enrollment_id) as count_of_enrollment
from [dbo].[Enrollments]
Group by user_id) as subquery
--
select top 10 user_id, count(enrollment_id) 
from [dbo].[Enrollments]
group by user_id


--2.2. Hansı ölkədən daha çox istifadəçi var?
select count(user_id)as count_userid, country
from [dbo].[Users]
group by country
order by country asc

--3. Hər kursun tamamlanma faizi
Select 
    c.course_name,
    Count(e.enrollment_id) AS total_enrollments,
    Sum(CASE WHEN e.completed = 1 THEN 1 ELSE 0 END) AS completed_count,
    Round(
      100.0 * SUM(CASE WHEN e.completed = 1 THEN 1 ELSE 0 END) / COUNT(e.enrollment_id), 
      2
    ) as completion_rate
From Enrollments e
JOIN Courses c ON e.course_id = c.course_id
Group By c.course_name
Order By completion_rate desc;

-- 4. Hər kursda neçə forum paylaşımı var?
select count(post_id) as total_post, c.course_name
from [dbo].[Forum_Posts] as f
join [dbo].[Courses] as c 
on f.course_id = c.course_id
Group by c.course_name

--5. İmtahanların orta balı hansılardır?
Select
    q.quiz_id,
    q.quiz_title,
    Round(AVG(qa.score), 2) AS avg_score
From Quiz_Attempts qa
Join Quizzes q ON qa.quiz_id = q.quiz_id
Group by q.quiz_id, q.quiz_title
Order by avg_score DESC;


--6. İstifadəçilər ən çox hansı cihazdan istifadə edirlər?
select count (user_id) as total_users, device 
from [dbo].[Users]
Group by device

--7. Tamamlanma faizi ilə imtahan nəticələri arasında əlaqə varmı?
-- Kurs adı, ortalama imtahan balı, tamamlanma faizi
SELECT 
    c.course_name,
    ROUND(AVG(qa.score), 2) AS avg_quiz_score,
    ROUND(
        100.0 * SUM(CASE WHEN e.completed = 1 THEN 1 ELSE 0 END) 
        / COUNT(e.enrollment_id), 
    2) AS completion_rate
FROM Courses c
JOIN Enrollments e 
    ON c.course_id = e.course_id
JOIN Quiz_Attempts qa 
    ON qa.user_id = e.user_id 
GROUP BY c.course_name
ORDER BY completion_rate DESC;

--8. Aylara görə qeydiyyat sayı (trendlər)
Select
    Format(registration_date, 'yyyy-MM') AS month,
    COUNT(user_id) AS registrations
From Users
Group by FORMAT(registration_date, 'yyyy-MM')
order by month;


--9. Sertifikat alanların sayı və faizi
select count (*) as total_enrollments, 
sum(case when certificate_earned = 1 then 1 else 0 end) as total_cert,
Round (100.0 * sum(case when certificate_earned = 1 then 1 else 0 end) / Count(*),2) as rate 
from Enrollments

--10. Forumda aktiv olanların imtahan nəticələri yüksəkdir?
select  
    case 
        when fp.user_id IS NOT NULL THEN 'Forum Active'
        else 'Forum Inactive'
    end as forum_participation,
    round (AVG(qa.score), 2) as avg_score
from Users u
LEFT JOIN Forum_Posts fp ON u.user_id = fp.user_id
LEFT JOIN Quiz_Attempts qa ON u.user_id = qa.user_id
group by case
        when fp.user_id IS NOT NULL THEN 'Forum Active'
        Else 'Forum Inactive'
    END;


--11 Top 5 yüksək bal alan istifadəçilər
select top 5 u.name, u.gender, qa.score
from Users as u
left join Quiz_Attempts as qa on u.user_id=qa.user_id
order by qa.score desc


