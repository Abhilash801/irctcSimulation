use UC
--select * from ScBzaTrains
CREATE VIEW Scbza as
select s1.arrivaltimeminutes-s2.arrivaltimeminutes as timegap,
case when s1.stationcode='bza' then 'bza2sc'
else 'sc2bza'
end route,s1.trainno,s1.trainname,s1.arrivaltimeminutes arrivalTimeStation1,s2.arrivaltimeminutes arrivalTimeStation2 from sc2bzaonly s1
inner join sc2bzaonly s2
on s1.trainno=s2.trainno
where s1.stationcode!=s2.stationcode
and s1.arrivaltimeminutes-s2.arrivaltimeminutes<0

select * from scbza 
where route='bza2sc'
order by arrivalTimeStation1

select * from [dbo].[ScBzaOnlyOneStation]
where stationcode='bza'
order by arrivaltimeminutes