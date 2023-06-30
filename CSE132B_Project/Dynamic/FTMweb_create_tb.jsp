<%@  page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title> Student Data</title>
    </head>
    <body>
        <!-- set the scripting lang to java and sql -->
        <%@ page language="java" import="java.sql.*" %>
        <%@ page language="java" import="net.FTM" %>
        <%
        int x = 0;
        String xx="";
        try{
            DriverManager.registerDriver(new org.postgresql.Driver());
            // create if not exist
            boolean ifexist = FTM.exist_db("tritonlink");
            if (!ifexist){
                FTM.create_db("tritonlink");
                out.println("created now "+ FTM.exist_db("tritonlink") +"<br>");
            }

            Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost/postgres?user=postgres&password=12345");
            Statement stmt = conn.createStatement();
            String sql_create = "CREATE TABLE student ("+
" student_id VARCHAR(50),"+
" first_name VARCHAR(50) NOT NULL,"+
" last_name VARCHAR(50) NOT NULL,"+
" middle_name VARCHAR(50),"+
" social_security_num INT NOT NULL,"+
" is_enrolled BOOLEAN,"+
" ca BOOLEAN,"+ // missing residence
" major VARCHAR(50)," + // " major VARCHAR(50) NOT NULL,"...optional now
" minor VARCHAR(50)," +
" PRIMARY KEY (student_id)"+
");"+
"CREATE TABLE degree("+
"degree VARCHAR(50) NOT NULL CONSTRAINT degree_check CHECK(degree in ('BS','MS','PhD','MS/BS')),"+
" school VARCHAR(50) NOT NULL,"+
" PRIMARY KEY(degree,school)"+
");"+
"CREATE TABLE faculty("+
"name VARCHAR(50),"+
" department VARCHAR(50) NOT NULL,"+
" title VARCHAR(50) NOT NULL,"+
" PRIMARY KEY(name)"+
");"+
"CREATE TABLE course("+
"c_number VARCHAR(50),"+
" consent BOOLEAN NOT NULL,"+
" lab BOOLEAN NOT NULL,"+
" min_units INT NOT NULL,"+
" max_units INT NOT NULL,"+
" g_option VARCHAR(50) NOT NULL,"+
" department VARCHAR(50) NOT NULL,"+
" PRIMARY KEY (c_number),"+
" CONSTRAINT units1 CHECK( min_units > 0),"+
" CONSTRAINT units2 CHECK( max_units >= min_units),"+
" CONSTRAINT grade_option CHECK (g_option in ('Letter','S/U','Letter or S/U'))"+
");"+
"CREATE TABLE section("+
"section_id INT,"+
" s_year INT NOT NULL,"+
" enroll_limit INT NOT NULL,"+
" mandatory BOOLEAN NOT NULL, "+
" quarter VARCHAR(50), "+ // quarter !!!!!!!!!!!!!!!!!!!!!  ALTER TABLE section ADD quarter VARCHAR(50);
" PRIMARY KEY(section_id,s_year), " +
" CONSTRAINT quarter_c CHECK(quarter in ('Fall','Winter','Spring','SummerI','SummerII'))"+ // section has quarter....put as more as information into entity, unless it has to be put into relational table
");"+
"CREATE TABLE research("+
" name VARCHAR(50),"+
" funding INT NOT NULL,"+
" PRIMARY KEY (name)"+
");"+
"CREATE TABLE uCSD_Degree("+
"department VARCHAR(50),"+
" major VARCHAR(50),"+
" level VARCHAR(50),"+
" min_units INT,"+
" PRIMARY KEY (department,major,level),"+
" CONSTRAINT level_check CHECK(level in ('BS','MS','PhD','MS/BS'))"+
");"+
""+
" CREATE TABLE teaching("+
" section_id INT,"+
" s_year INT NOT NULL,"+
" f_name VARCHAR(50),"+
" FOREIGN KEY (section_id,s_year) REFERENCES section(section_id,s_year),"+
" FOREIGN KEY (f_name) REFERENCES faculty(name)"+
");"+
"CREATE TABLE undergraduates("+
" student_id VARCHAR(50),"+
" UCSD_College VARCHAR(50) NOT NULL,"+
" FOREIGN KEY (student_id) REFERENCES student(student_id),"+
" CONSTRAINT college CHECK(UCSD_College in ('Revelle','John Muir','Thurgood Marshall','Eleanor Roosevelt','Earl Warren','Sixth','Seventh'))"+
");"+
""+
"CREATE TABLE graduates("+
" student_id VARCHAR(50),"+
" department VARCHAR(50) NOT NULL,"+
" level VARCHAR(50) NOT NULL,"+
" thesis_name VARCHAR(50),"+
" PRIMARY KEY (thesis_name),"+
" FOREIGN KEY (student_id) REFERENCES student(student_id),"+
" CONSTRAINT level_check CHECK(level in ('MS','PhD','MS/BS'))"+
");"+
"CREATE TABLE attendance("+
"student_id VARCHAR(50),"+
" s_quarter VARCHAR(50) NOT NULL,"+
" s_school_year INT NOT NULL,"+
" e_quarter VARCHAR(50) NOT NULL,"+
" e_school_year INT NOT NULL,"+
" FOREIGN KEY (student_id) REFERENCES student(student_id),"+
" CONSTRAINT quarter_s CHECK(s_quarter in ('Fall','Winter','Spring','SummerI','SummerII')),"+
" CONSTRAINT s_year CHECK(s_school_year <= e_school_year),"+
" CONSTRAINT quarter_e CHECK(e_quarter in ('Fall','Winter','Spring','SummerI','SummerII')),"+
" CONSTRAINT e_year CHECK(e_school_year >= s_school_year)"+
");"+
"CREATE TABLE probation("+
"student_id VARCHAR(50),"+
" s_quarter VARCHAR(50) NOT NULL,"+
" s_school_year INT NOT NULL,"+
" e_quarter VARCHAR(50) NOT NULL,"+
" e_school_year INT NOT NULL,"+
" FOREIGN KEY (student_id) REFERENCES student(student_id),"+
" CONSTRAINT quarter_s CHECK(s_quarter in ('Fall','Winter','Spring','SummerI','SummerII')),"+
" CONSTRAINT s_year CHECK(s_school_year <= e_school_year),"+
" CONSTRAINT quarter_e CHECK(e_quarter in ('Fall','Winter','Spring','SummerI','SummerII')),"+
" CONSTRAINT e_year CHECK(e_school_year >= s_school_year)"+
");"+
"CREATE TABLE previous_D("+
"student_id VARCHAR(50),"+
" degree VARCHAR(50),"+
" school VARCHAR(50),"+
" PRIMARY KEY(student_id,degree,school),"+
" FOREIGN KEY (student_id) REFERENCES student(student_id),"+
" CONSTRAINT degree_check CHECK(degree in ('BS','MS','PhD','MS/BS'))"+
");"+
""+
"CREATE TABLE weekly_Meeting("+
//"id SERIAL PRIMARY KEY,"+ // 0607__add the serial key, otherwise no primary key or unique foreign key
"section_id INT,"+
" s_year INT,"+
" m_type VARCHAR(50),"+
" m_day VARCHAR(50) NOT NULL,"+ // here within monday, tuesday....
" start_t TIME NOT NULL," +
" end_t TIME NOT NULL," +
" room VARCHAR(50) NOT NULL,"+
// " PRIMARY KEY(section_id,s_year,m_type),"+ // it should not have primary key
" FOREIGN KEY (section_id,s_year) REFERENCES section(section_id,s_year),"+
" CONSTRAINT m_check CHECK(m_type in ('LE','DI','LA','SE')),"+
" CONSTRAINT day_check CHECK(m_day in ('M','Tu','W','Th','F','Sa','Su')),"+
" CONSTRAINT st CHECK(start_t <= end_t),"+
" CONSTRAINT et CHECK(end_t >= start_t)"+
");"+
"CREATE TABLE review("+
//"id SERIAL PRIMARY KEY,"+ // 0607__add the serial key, otherwise no primary key or unique foreign key
"section_id INT,"+
" s_year INT,"+
" date date NOT NULL,"+
" start_t TIME NOT NULL,"+
" end_t TIME NOT NULL,"+
" FOREIGN KEY (section_id,s_year) REFERENCES section(section_id,s_year),"+
" CONSTRAINT st CHECK(start_t <= end_t),"+
" CONSTRAINT et CHECK(end_t >= start_t)"+
");"+
///////MOVED HERE
"CREATE TABLE classes("+
"c_number VARCHAR(50),"+
" section_id INT,"+
" quarter VARCHAR(50),"+  // wang's affect
" s_year INT,"+
" title VARCHAR(50) NOT NULL,"+
" PRIMARY KEY (c_number,section_id, s_year),"+
" FOREIGN KEY (c_number) REFERENCES course(c_number),"+
" FOREIGN KEY (section_id,s_year) REFERENCES section(section_id,s_year),"+
" CONSTRAINT quarter_c CHECK(quarter in ('Fall','Winter','Spring','SummerI','SummerII'))"+ // wang's affect
");"+
"CREATE TABLE enrollment("+
"student_id VARCHAR(50),"+
" c_number VARCHAR(50),"+
" section_id INT,"+
" s_year INT,"+
" option VARCHAR(50) NOT NULL,"+
" units INT NOT NULL,"+
" grade VARCHAR(50) NOT NULL,"+
" PRIMARY KEY (student_id,section_id, s_year),"+
" FOREIGN KEY (student_id) REFERENCES student(student_id),"+
" FOREIGN KEY (c_number) REFERENCES course(c_number),"+ // affect wang's
// A+ can't insert
" FOREIGN KEY (c_number,section_id,s_year) REFERENCES classes(c_number,section_id,s_year),"+ /////////ADDED THIS
" CONSTRAINT grade_options CHECK(option in ('Letter','S/U','Letter or S/U'))"+
// " CONSTRAINT c_grade CHECK(grade IN ('A+', 'A','A-','B+','B','B-','C+','C','C-','D','IN','S','U'))"+ // already forced in type in front end
");"+
"CREATE TABLE equivalent_num("+
" c_number VARCHAR(50),"+
"old_num VARCHAR(50),"+
" the_year INT,"+
" PRIMARY KEY (old_num, the_year),"+
" FOREIGN KEY (c_number) REFERENCES course(c_number)"+
");"+
"CREATE TABLE waitlist("+
"student_id VARCHAR(50),"+
" section_id INT,"+
" c_number VARCHAR(50),"+
" s_year INT,"+
" option VARCHAR(50) NOT NULL,"+
" units INT NOT NULL,"+
" PRIMARY KEY (student_id,Section_id, s_year),"+
" FOREIGN KEY (student_id) REFERENCES student(student_id),"+
" FOREIGN KEY (c_number) REFERENCES course(c_number),"+
" FOREIGN KEY (c_number,section_id,s_year) REFERENCES classes(c_number,section_id,s_year),"+ //////ADDED THIS
" CONSTRAINT grade_options CHECK(option in ('Letter','S/U','Letter or S/U'))"+
");"+
"CREATE TABLE work_on_Research("+
"student_id VARCHAR(50),"+
" name VARCHAR(50),"+
" hour_wage REAL,"+
" PRIMARY KEY(student_id,name),"+
" FOREIGN KEY (student_id) REFERENCES student(student_id),"+
" FOREIGN KEY (name) REFERENCES research(name)"+
");"+
"CREATE TABLE research_lead("+
"f_name VARCHAR(50),"+
" name VARCHAR(50),"+
" PRIMARY KEY(f_name,name),"+
" FOREIGN KEY (f_name) REFERENCES faculty(name),"+
" FOREIGN KEY (name) REFERENCES research(name)"+
");"+
"CREATE TABLE thesis_Committee("+
"thesis_name VARCHAR(50),"+
" f_name VARCHAR(50),"+
" FOREIGN KEY (thesis_name) REFERENCES graduates(thesis_name),"+
" FOREIGN KEY (f_name) REFERENCES faculty(name)"+
");"+
"CREATE TABLE advisory("+
"thesis_name VARCHAR(50),"+
" f_name VARCHAR(50),"+
" FOREIGN KEY (thesis_name) REFERENCES graduates(thesis_name),"+
" FOREIGN KEY (f_name) REFERENCES faculty(name)"+
");"+
"CREATE TABLE prerequirement("+
" c_number VARCHAR(50),"+
" pre_c_number VARCHAR(50),"+
" FOREIGN KEY (c_number) REFERENCES course(c_number),"+
" FOREIGN KEY (pre_c_number) REFERENCES course(c_number)"+
");"+
"CREATE TABLE cat_belong("+
" c_name VARCHAR(50),"+
"c_number VARCHAR(50),"+
" PRIMARY KEY(c_number,c_name),"+
" FOREIGN KEY (c_number) REFERENCES course(c_number)"+
");"+
"CREATE TABLE con_belong("+
" con_name VARCHAR(50),"+
"c_number VARCHAR(50),"+
" PRIMARY KEY(c_number,con_name),"+
" FOREIGN KEY (c_number) REFERENCES course(c_number)"+
");"+
"CREATE TABLE con_Requirement("+
"con_name VARCHAR(50),"+
" department VARCHAR(50),"+
" major VARCHAR(50),"+
" level VARCHAR(50),"+
" min_units INT,"+
" min_gpa REAL, "+ // add
" FOREIGN KEY (department, major, level) REFERENCES uCSD_Degree(department, major,level),"+
" CONSTRAINT level_check CHECK(level in ('BS','MS','PhD','MS/BS'))"+
");"+
"CREATE TABLE cat_Requirement("+
"c_name VARCHAR(50),"+
" department VARCHAR(50),"+
" major VARCHAR(50),"+
" level VARCHAR(50),"+
" min_units INT,"+
" min_gpa REAL, "+
" FOREIGN KEY (department, major, level) REFERENCES uCSD_Degree(department, major,level),"+
" CONSTRAINT level_check CHECK(level in ('BS','MS','PhD','MS/BS'))"+
");";

// -- # relations in sql, make it not work

            String[] sql_create_list=sql_create.split(";");
            for(int i=0;i<sql_create_list.length;i++){
                xx = sql_create_list[i]+";";
                stmt.executeUpdate(sql_create_list[i]+";");
                xx = String.valueOf(i);
                // out.println(sql_create_list[i]+<br>);
            }
           //create conversion table
            String r8_Query = "CREATE TABLE grade_conversion( "+
                                    "letter_grade CHAR(10) NOT NULL, "+
                                    "number_grade DECIMAL(2,1))";
                Statement stmt2 = conn.createStatement();
                stmt2.executeUpdate(r8_Query);
                stmt2.executeUpdate("insert into grade_conversion values('A PLUS', 4.3)");
                stmt2.executeUpdate("insert into grade_conversion values('A', 4)");
                stmt2.executeUpdate("insert into grade_conversion values('A-', 3.7)");
                stmt2.executeUpdate("insert into grade_conversion values('B PLUS', 3.4)");
                stmt2.executeUpdate("insert into grade_conversion values('B', 3.1)");
                stmt2.executeUpdate("insert into grade_conversion values('B-', 2.8)");
                stmt2.executeUpdate("insert into grade_conversion values('C PLUS', 2.5)");
                stmt2.executeUpdate("insert into grade_conversion values('C', 2.2)");
                stmt2.executeUpdate("insert into grade_conversion values('C-', 1.9)");
                stmt2.executeUpdate("insert into grade_conversion values('D', 1.6)");
                stmt2.executeUpdate("insert into grade_conversion values('IN', 0)");
                stmt2.executeUpdate("insert into grade_conversion values('S', 0)");
                stmt2.executeUpdate("insert into grade_conversion values('U', 0)");
            //create material views
            // Check if the materialized view exists
            /*
                String query = "SELECT EXISTS(SELECT 1 FROM pg_matviews WHERE matviewname = 'cpqg' OR matviewname = 'cpg')";
                Statement stmt1 = conn.createStatement();
                ResultSet rs1 = stmt1.executeQuery(query);
                boolean viewExists = false;
                while(rs1.next()){
                    viewExists = rs1.getBoolean(1);
                }
                if (!viewExists) {
            */
                    //The materialized view does not exist
                    //create materialized views
                Statement stmt1 = conn.createStatement();
                    String CPQG = "CREATE TABLE CPQG AS ( "+
                                    "SELECT y.c_number, x.f_name, z.quarter, z.s_year,grade, COUNT(grade) AS count "+
                                                "FROM teaching x, enrollment y, classes z "+
                                                "WHERE y.section_id = x.section_id AND "+
                                                    "y.s_year = x.s_year AND "+
                                                    "x.section_id = z.section_id AND "+
                                                    "x.s_year = z.s_year AND "+
                                                    "y.c_number = z.c_number "+
                                                "GROUP BY (y.c_number, x.f_name, z.quarter, z.s_year,grade));";
                    String CPG = "CREATE TABLE CPG AS( "+
                                    "SELECT y.c_number,x.f_name,grade, COUNT(grade) AS count "+
                                        "FROM teaching x, enrollment y "+
                                        "WHERE y.section_id = x.section_id AND "+
                                        "y.s_year = x.s_year "+
                                        "GROUP BY (y.c_number,x.f_name,grade));";
                    stmt1.executeUpdate(CPQG);
                    stmt1.executeUpdate(CPG);
                    //create trigger/trigger function for CPQG
                    String insert_func = "CREATE OR REPLACE FUNCTION insert_to_materialized_view() "+
                                            "RETURNS TRIGGER AS ' "+
                                            "DECLARE "+
                                            "    professor_name VARCHAR(50); "+
                                            "    grab_quarter VARCHAR(50); "+
                                            "    element_exists_cpqg BOOLEAN; "+
                                            "BEGIN "+
                                            "    SELECT f_name INTO professor_name "+
                                            "    FROM teaching "+
                                            "    WHERE section_id = NEW.section_id AND s_year = NEW.s_year; "+
                                            "    SELECT quarter INTO grab_quarter "+
                                            "    FROM classes "+
                                            "    WHERE section_id = NEW.section_id AND s_year = NEW.s_year AND c_number = NEW.c_number; "+
                                            "    SELECT EXISTS (SELECT 1 FROM cpqg WHERE c_number = NEW.c_number AND f_name = professor_name AND quarter = grab_quarter AND s_year = NEW.s_year AND grade = NEW.grade) INTO element_exists_cpqg; "+
                                            "    IF element_exists_cpqg THEN "+
                                            "      UPDATE CPQG "+
                                            "      SET count = count + 1 "+
                                            "      WHERE c_number = NEW.c_number AND f_name = professor_name AND quarter = grab_quarter AND s_year = NEW.s_year AND grade = NEW.grade; "+
                                            "      UPDATE CPG "+
                                            "      SET count = count + 1 "+
                                            "      WHERE c_number = NEW.c_number AND f_name = professor_name AND grade = NEW.grade; "+
                                            "    ELSE "+
                                            "      INSERT INTO CPQG(c_number, f_name, quarter, s_year, grade, count) VALUES (NEW.c_number, professor_name, grab_quarter, NEW.s_year, NEW.grade, 1); "+
                                            "      INSERT INTO CPG(c_number, f_name, grade,count) VALUES (NEW.c_number, professor_name, NEW.grade, 1); "+
                                            "    END IF; "+
                                            "    RETURN NEW; "+
                                            "END; "+
                                            "' LANGUAGE plpgsql;";
                    String update_func = "CREATE OR REPLACE FUNCTION update_to_materialized_view() "+
                                            "RETURNS TRIGGER AS ' "+
                                            "DECLARE "+
                                            "    professor_name VARCHAR(50); "+
                                            "    grab_quarter VARCHAR(50); "+
                                            "    grab_grade VARCHAR(50); "+
                                            "    element_exists_cpqg BOOLEAN; "+
                                            "BEGIN "+
                                            "    SELECT f_name INTO professor_name "+
                                            "    FROM teaching "+
                                            "    WHERE section_id = NEW.section_id AND s_year = NEW.s_year; "+
                                            "    SELECT quarter INTO grab_quarter "+
                                            "    FROM classes "+
                                            "    WHERE section_id = NEW.section_id AND s_year = NEW.s_year AND c_number = NEW.c_number; "+
                                            "    SELECT grade INTO grab_grade "+
                                            "    FROM CPQG "+
                                            "    WHERE c_number = NEW.c_number AND f_name = professor_name AND quarter = grab_quarter AND s_year = NEW.s_year AND grade = NEW.grade; "+
                                            "    SELECT EXISTS (SELECT 1 FROM cpqg WHERE c_number = NEW.c_number AND f_name = professor_name AND quarter = grab_quarter AND s_year = NEW.s_year AND grade = NEW.grade) INTO element_exists_cpqg; "+
                                            "    IF element_exists_cpqg THEN "+
                                            "      UPDATE CPQG "+
                                            "      SET count = count - 1 "+
                                            "      WHERE c_number = NEW.c_number AND f_name = professor_name AND quarter = grab_quarter AND s_year = NEW.s_year AND grade = OLD.grade; "+
                                            "      UPDATE CPG "+
                                            "      SET count = count - 1 "+
                                            "      WHERE c_number = NEW.c_number AND f_name = professor_name AND grade = OLD.grade; "+
                                            "      UPDATE CPQG "+
                                            "      SET count = count + 1 "+
                                            "      WHERE c_number = NEW.c_number AND f_name = professor_name AND quarter = grab_quarter AND s_year = NEW.s_year AND grade = NEW.grade; "+
                                            "      UPDATE CPG "+
                                            "      SET count = count + 1 "+
                                            "      WHERE c_number = NEW.c_number AND f_name = professor_name AND grade = NEW.grade; "+
                                            "    ELSE "+
                                            "      UPDATE CPQG "+
                                            "      SET count = count - 1 "+
                                            "      WHERE c_number = NEW.c_number AND f_name = professor_name AND quarter = grab_quarter AND s_year = NEW.s_year AND grade = OLD.grade; "+
                                            "      UPDATE CPG "+
                                            "      SET count = count - 1 "+
                                            "      WHERE c_number = NEW.c_number AND f_name = professor_name AND grade = OLD.grade; "+
                                            "      INSERT INTO CPQG(c_number, f_name, quarter, s_year, grade, count) VALUES (NEW.c_number, professor_name, grab_quarter, NEW.s_year, NEW.grade, 1); "+
                                            "      INSERT INTO CPG(c_number, f_name, grade,count) VALUES (NEW.c_number, professor_name, NEW.grade, 1); "+
                                            "    END IF; "+
                                            "    RETURN NEW; "+
                                            "END; "+
                                            "' LANGUAGE plpgsql;";
                    String delete_func = "CREATE OR REPLACE FUNCTION delete_to_materialized_view() "+
                                            "RETURNS TRIGGER AS ' "+
                                            "DECLARE "+
                                            "    professor_name VARCHAR(50); "+
                                            "    grab_quarter VARCHAR(50); "+
                                            "BEGIN "+
                                            "    SELECT f_name INTO professor_name "+
                                            "    FROM teaching "+
                                            "    WHERE section_id = OLD.section_id AND s_year = OLD.s_year; "+
                                            "    SELECT quarter INTO grab_quarter "+
                                            "    FROM classes "+
                                            "    WHERE section_id = OLD.section_id AND s_year = OLD.s_year AND c_number = OLD.c_number; "+
                                            "    UPDATE CPQG "+
                                            "    SET count = count - 1 "+
                                            "    WHERE c_number = OLD.c_number AND f_name = professor_name AND quarter = grab_quarter AND s_year = OLD.s_year AND grade = OLD.grade; "+
                                            "    UPDATE CPG "+
                                            "    SET count = count - 1 "+
                                            "    WHERE c_number = OLD.c_number AND f_name = professor_name AND grade = OLD.grade; "+
                                            "    RETURN OLD; "+
                                            "END; "+
                                            "' LANGUAGE plpgsql;";
                    stmt1.executeUpdate(insert_func);
                    stmt1.executeUpdate(update_func);
                    stmt1.executeUpdate(delete_func);
                    //create triggers
                    String insert_trigger = "CREATE TRIGGER insert_trigger "+
                                            "AFTER INSERT ON enrollment "+
                                            "FOR EACH ROW "+
                                            "EXECUTE FUNCTION insert_to_materialized_view();";
                    String update_trigger = "CREATE TRIGGER update_trigger "+
                                            "AFTER UPDATE ON enrollment "+
                                            "FOR EACH ROW "+
                                            "EXECUTE FUNCTION update_to_materialized_view();";
                    String delete_trigger = "CREATE TRIGGER delete_trigger "+
                                            "AFTER DELETE ON enrollment "+
                                            "FOR EACH ROW "+
                                            "EXECUTE FUNCTION delete_to_materialized_view();";
                    stmt1.executeUpdate(insert_trigger);
                    stmt1.executeUpdate(update_trigger);
                    stmt1.executeUpdate(delete_trigger);
            // xx = String.join("<br>",sql_create_list);//"success";
            
            // get all table names
            //xx = "";
            /*
            ResultSet rs = stmt.executeQuery("\\dt"); // Show tables
            while(rs.next()) {
                xx += rs.getString(1)+"<br>";
            }*/
            DatabaseMetaData metaData = conn.getMetaData();
            String[] types = {"TABLE"};
            //Retrieving the columns in the database
            ResultSet tables = metaData.getTables(null, null, "%", types);
            String[] table_res = new String[sql_create_list.length];
            for(int i=0;tables.next();i++){
                table_res[i] = tables.getString("TABLE_NAME");
            }

            // not exists
            String[] table_names = {"student", "times", "degree", "faculty", "meeting_Times", "course", "section", "research", "thesis", "category", "concentration", "uCSD_Degree","teaching", "undergraduates", "graduates", "attendance", "probation", "previous_D", "weekly_Meeting", "review", "enrollment", "equivalent_num", "waitlist", "classes", "work_on_Research", "research_lead", "thesis_Committee", "advisory", "prerequirement" ,"cat_belong", "con_belong", "con_Requirement", "cat_Requirement"};
            xx += "<br>"+ String.valueOf(table_names.length)+"__"+String.valueOf(table_res.length);
            for(int j=0;j<table_names.length;j++){
                Boolean exist=false;
                int i=0;
                for(i=0;i<table_res.length;i++)
                    if(table_res[i]!=null && table_names[j].toLowerCase().equals(table_res[i].toLowerCase())){
                        exist=true;
                        break;
                    }
                xx += "<br>"+String.valueOf(j)+"__"+table_names[j]+"___";
                if(!exist){
                    xx += table_names[j] + "________________fails";
                } else{
                    xx += String.valueOf(i);
                }
            }

            conn.close();
        }catch(Exception e){
            e.printStackTrace();
            xx = "fail__"+xx;
            x = 0;
        }
        %>


            <span> result is <%= xx %> </span>


    </body>
</html>
