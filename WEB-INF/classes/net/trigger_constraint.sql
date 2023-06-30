-- drop already tigger to refresh
DROP TRIGGER if exists meeting_notsame_ on weekly_meeting;
DROP TRIGGER if exists enroll_limits_ on enrollment;
DROP TRIGGER if exists teaching_notsame_ on teaching;
DROP TRIGGER if exists weekly_teach_notconflilct_ on weekly_meeting;
DROP TRIGGER if exists review_conflict_ on review;

-- add serial for weekly_meeting and reviews, in case that they can update and delete
ALTER TABLE weekly_meeting
ADD COLUMN if not exists meeting_id SERIAL PRIMARY KEY;
ALTER TABLE review
ADD COLUMN if not exists review_id SERIAL PRIMARY KEY;

-- check for section enrollment limits ??? -- also for some
CREATE OR REPLACE FUNCTION meeting_notsame()
RETURNS TRIGGER AS $$
DECLARE
its_id INT;
its_year int;
its_m_day varchar(50);
its_start time;
its_end time;
row_l int;
its_mid int;
BEGIN
    its_id := new.section_id;
    its_year := new.s_year;
    its_m_day := new.m_day;
    its_start := new.start_t;
    its_end := new.end_t;
    its_mid := new.meeting_id;
    RAISE NOTICE 'meeting_id #: %', its_mid;

    -- get all occupied time slot-->conflicting meeting with new one....also need to exclude itself !!!...other also need to exclude this
    create temporary table confliting_meeting as
    select m_day, start_t, end_t from weekly_meeting where section_id = its_id and meeting_id != its_mid  and s_year = its_year and its_m_day = m_day and ((its_start, its_end) OVERLAPS (start_t, end_t));

    row_l := 0;
    select count(*) into row_l from confliting_meeting;
    --RAISE NOTICE 'confliting_meeting #: %', row_l;

    IF row_l > 0 THEN
        RAISE NOTICE 'confliting_meeting #: %', row_l;
        RAISE EXCEPTION 'weekly meetings of the same section should not happen at same time';
    END IF;
    drop table confliting_meeting;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER meeting_notsame_
BEFORE INSERT or update ON weekly_meeting
FOR EACH ROW
EXECUTE FUNCTION meeting_notsame();





-- check for maximum enrollment
CREATE OR REPLACE FUNCTION enroll_limits()
RETURNS TRIGGER AS $$
DECLARE
its_std varchar(50);
its_id INT;
its_year int;
its_limit int;
row_l int;
BEGIN
    its_std := new.student_id;
    its_id := new.section_id;
    its_year := new.s_year;
    row_l := 0;
    its_limit:= 0;
    -- # (already enrolled)
    create temporary table enrolled as
    select student_id from enrollment where section_id = its_id and s_year = its_year;
    select count(*) into row_l from enrolled;
    -- # (enroll_limit)
    select enroll_limit into its_limit from section where section_id = its_id and s_year = its_year;
    -- check if already in....no need to check, already as primary key
    select count(*) into row_l from enrolled where student_id = its_std;
    IF row_l > 0 THEN
        RAISE EXCEPTION 'he/she has already enrolled this section';
    END IF;
    -- check exceed enroll_limit
    select count(*) into row_l from enrolled;
    if row_l >= its_limit then
        raise exception 'exceed the enrollment limits';
    end if;

    drop table enrolled;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enroll_limits_
BEFORE INSERT or update ON enrollment
FOR EACH ROW
EXECUTE FUNCTION enroll_limits();





-- check for professor's section's meeting not at same time
CREATE OR REPLACE FUNCTION teaching_notsame()
RETURNS TRIGGER AS $$
DECLARE
his_name varchar(50);
its_q varchar(50);
its_year int;
its_sid int;
row_l int;
BEGIN
    --initialize value
    his_name := new.f_name;
    its_year := new.s_year;
    its_sid := new.section_id;
    its_q := 'Spring';
    select quarter into its_q from section where s_year = its_year and section_id = its_sid;
    -- get all section taught...but only same quarter...must use '', or take as column
    create temporary table all_section as
    select section_id from teaching where s_year = its_year and f_name = his_name and section_id in (select section_id from section where s_year = its_year and quarter = its_q);
    -- get all meetings--regular, review--already
    create temporary table weekly_old as
    select case m_day
            when 'M' then 1
            when 'Tu' then 2
            when 'W' then 3
            when 'Th' then 4
            when 'F' then 5
            when 'Sa' then 6
            when 'Su' then 7
            else null
        end as day
    , start_t, end_t
    from weekly_meeting where s_year = its_year and section_id in (select section_id from all_section);
    create temporary table single_old as
    select date, start_t, end_t from review where s_year = its_year and section_id in (select section_id from all_section);
    -- get all meetings--regular--new
    create temporary table weekly_new as
    select case m_day
            when 'M' then 1
            when 'Tu' then 2
            when 'W' then 3
            when 'Th' then 4
            when 'F' then 5
            when 'Sa' then 6
            when 'Su' then 7
            else null
        end as day
    , start_t, end_t
    from weekly_meeting where s_year = its_year and section_id = its_sid;
    create temporary table single_new as
    select date, start_t, end_t from review where s_year = its_year and section_id = its_sid;
    -- check conflict
    row_l := 0;
    -- check conflicting between weekly_old and weekly_new
    select count(*) into row_l from weekly_old where exists (select 1 from weekly_new where
    weekly_old.day = weekly_new.day and ((weekly_new.start_t, weekly_new.end_t) OVERLAPS (weekly_old.start_t, weekly_old.end_t)));
    IF row_l > 0 THEN
        RAISE EXCEPTION 'the new section has at least 1 confliction of weekly meeting with that of the sections already taught by the professor';
    END IF;
    -- check conflicting between weekly_old and single_new
    select count(*) into row_l from weekly_old where exists (select 1 from single_new where
    weekly_old.day = extract(dow from single_new.date) and ((single_new.start_t, single_new.end_t) OVERLAPS (weekly_old.start_t, weekly_old.end_t)));
    IF row_l > 0 THEN
        RAISE EXCEPTION 'the new section has at least 1 confliction of review session with the weekly meetings of the sections already taught by the professor';
    END IF;
    -- check conflicting between single_old and weekly_new
    select count(*) into row_l from single_old where exists (select 1 from weekly_new where
    extract(dow from single_old.date) = weekly_new.day and ((weekly_new.start_t, weekly_new.end_t) OVERLAPS (single_old.start_t, single_old.end_t)));
    IF row_l > 0 THEN
        RAISE EXCEPTION 'the new section has at least 1 confliction of weekly meeting with the review sessions of the sections already taught by the professor';
    END IF;
    -- check conflicting between single_old and single_new
    select count(*) into row_l from single_old where exists (select 1 from single_new where
    single_old.date = single_new.date and ((single_new.start_t, single_new.end_t) OVERLAPS (single_old.start_t, single_old.end_t)));
    IF row_l > 0 THEN
        RAISE EXCEPTION 'the new section has at least 1 confliction of review session with that of the sections already taught by the professor';
    END IF;
    --drop table for late use
    drop table all_section;
    drop table weekly_old;
    drop table weekly_new;
    drop table single_old;
    drop table single_new;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER teaching_notsame_
BEFORE INSERT or update ON teaching
FOR EACH ROW
EXECUTE FUNCTION teaching_notsame();



-- in case insert/update new weekly_meeting, cause confliction
CREATE OR REPLACE FUNCTION weekly_teach_notconflilct()
RETURNS TRIGGER AS $$
DECLARE
his_name varchar(50);
its_q varchar(50);
its_year int;
its_sid int;
its_start time;
its_end time;
its_m_day varchar(50);
its_day int;
its_mid int;
row_l int;
BEGIN
    --initialize value
    its_year := new.s_year;
    its_sid := new.section_id;
    its_mid := new.meeting_id;
    select f_name into his_name from teaching where s_year = its_year and section_id = its_sid;
    select quarter into its_q from section where s_year = its_year and section_id = its_sid;
    -- get all section taught...but only same quarter...must use '', or take as column
    create temporary table all_section as
    select section_id from teaching where s_year = its_year and f_name = his_name and section_id in (select section_id from section where s_year = its_year and quarter = its_q);
    -- get all meetings--regular, review--already... exclude the itself
    create temporary table weekly_old as
    select case m_day
            when 'M' then 1
            when 'Tu' then 2
            when 'W' then 3
            when 'Th' then 4
            when 'F' then 5
            when 'Sa' then 6
            when 'Su' then 7
            else null
        end as day
    , start_t, end_t
    from weekly_meeting where s_year = its_year and section_id in (select section_id from all_section) and meeting_id != its_mid;
    create temporary table single_old as
    select date, start_t, end_t from review where s_year = its_year and section_id in (select section_id from all_section);
    -- get new meetings--regular--new
    its_m_day := new.m_day;
    its_day := case its_m_day
            when 'M' then 1
            when 'Tu' then 2
            when 'W' then 3
            when 'Th' then 4
            when 'F' then 5
            when 'Sa' then 6
            when 'Su' then 7
            else null
        end;
    its_start := new.start_t;
    its_end := new.end_t;
    -- check conflict
    row_l := 0;
    -- check conflicting between weekly_old and weekly_new
    select count(*) into row_l from weekly_old where ((weekly_old.start_t, weekly_old.end_t) OVERLAPS (its_start, its_end)) and weekly_old.day = its_day;
    IF row_l > 0 THEN
        RAISE EXCEPTION 'the new weekly_meeting has at least 1 confliction with that of the sections already taught by the professor';
    END IF;
    -- check conflicting between single_old and weekly_new
    select count(*) into row_l from single_old where ((single_old.start_t, single_old.end_t) OVERLAPS (its_start, its_end)) and extract(dow from single_old.date) = its_day;
    IF row_l > 0 THEN
        RAISE EXCEPTION 'the new weekly_meeting has at least 1 confliction with the review sessions of the sections already taught by the professor';
    END IF;
    --drop table for late use
    drop table all_section;
    drop table weekly_old;
    drop table single_old;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER weekly_teach_notconflilct_
BEFORE INSERT or update ON weekly_meeting
FOR EACH ROW
EXECUTE FUNCTION weekly_teach_notconflilct();



-- in case insert/update new review session, cause confliction
CREATE OR REPLACE FUNCTION review_conflict()
RETURNS TRIGGER AS $$
DECLARE
his_name varchar(50);
its_q varchar(50);
its_year int;
its_sid int;
its_start time;
its_end time;
its_date date;
its_rid int;
row_l int;
BEGIN
    --initialize value
    its_year := new.s_year;
    its_sid := new.section_id;
    its_rid := new.review_id;
    select f_name into his_name from teaching where s_year = its_year and section_id = its_sid;
    select quarter into its_q from section where s_year = its_year and section_id = its_sid;
    -- get all section taught...but only same quarter...must use '', or take as column
    create temporary table all_section as
    select section_id from teaching where s_year = its_year and f_name = his_name and section_id in (select section_id from section where s_year = its_year and quarter = its_q);
    -- get all meetings--regular, review--already
    create temporary table weekly_old as
    select case m_day
            when 'M' then 1
            when 'Tu' then 2
            when 'W' then 3
            when 'Th' then 4
            when 'F' then 5
            when 'Sa' then 6
            when 'Su' then 7
            else null
        end as day
    , start_t, end_t
    from weekly_meeting where s_year = its_year and section_id in (select section_id from all_section);
    create temporary table single_old as
    select date, start_t, end_t from review where s_year = its_year and section_id in (select section_id from all_section) and review_id != its_rid;
    -- get all meetings---new
    its_start := new.start_t;
    its_end := new.end_t;
    its_date := new.date;
    -- check conflict
    row_l := 0;
    -- check conflicting between weekly_old and single_new
    select count(*) into row_l from weekly_old where weekly_old.day = extract(dow from its_date) and ((weekly_old.start_t, weekly_old.end_t) OVERLAPS (its_start, its_end));
    IF row_l > 0 THEN
        RAISE EXCEPTION 'the new review session has at least 1 confliction with the weekly meetings of the sections already taught by the professor';
    END IF;
    -- check conflicting between single_old and single_new
    select count(*) into row_l from single_old where single_old.date = its_date and ((its_start, its_end) OVERLAPS (single_old.start_t, single_old.end_t));
    IF row_l > 0 THEN
        RAISE EXCEPTION 'the new review session has at least 1 confliction with that of the sections already taught by the professor';
    END IF;
    --drop table for late use
    drop table all_section;
    drop table weekly_old;
    drop table single_old;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER review_conflict_
BEFORE INSERT or update ON review
FOR EACH ROW
EXECUTE FUNCTION review_conflict();



