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
            Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost/postgres?user=postgres&password=12345");
            Statement stmt = conn.createStatement();
            stmt.executeUpdate("DROP TABLE IF EXISTS CPQG");
            stmt.executeUpdate("DROP TABLE IF EXISTS CPG");
            stmt.executeUpdate("DROP TRIGGER IF EXISTS insert_trigger ON enrollment");
            stmt.executeUpdate("DROP TRIGGER IF EXISTS update_trigger ON enrollment");
            stmt.executeUpdate("DROP TRIGGER IF EXISTS delete_trigger ON enrollment");
            stmt.executeUpdate("DROP FUNCTION IF EXISTS insert_to_materialized_view");
            stmt.executeUpdate("DROP FUNCTION IF EXISTS update_to_materialized_view");
            stmt.executeUpdate("DROP FUNCTION IF EXISTS delete_to_materialized_view");
            /*
            DROP TRIGGER IF EXISTS insert_trigger ON enrollment;
            DROP TRIGGER IF EXISTS update_trigger ON enrollment;
            DROP TRIGGER IF EXISTS delete_trigger ON enrollment;
            DROP FUNCTION IF EXISTS insert_to_materialized_view;
            DROP FUNCTION IF EXISTS update_to_materialized_view;
            DROP FUNCTION IF EXISTS delete_to_materialized_view;
            */
            //drop conversion grade tables
            stmt.executeUpdate("DROP TABLE IF EXISTS grade_conversion");
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
                //}
            
            xx= "good";
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
