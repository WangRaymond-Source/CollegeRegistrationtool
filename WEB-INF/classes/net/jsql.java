package net;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;
import java.sql.DatabaseMetaData;
import java.util.ArrayList;

import javax.lang.model.util.ElementScanner14;
import java.util.*;
import java.sql.Driver;

import java.time.LocalDate;
import java.time.Month;

import java.sql.SQLException;

import java.io.BufferedReader;
import java.io.FileReader;

import java.io.StringWriter;
import java.io.PrintWriter;
// import com.mysql.jdbc.Driver;

public class jsql {
    public static void main(String[] args) {
        System.out.println(FTM.exist_db("tritonlink"));
        // delete

        /**/
        // get_current_quarter();

        // try{
        // Class.forName("com.mysql.cj.jdbc.Driver"); // this is in mysql
        String connURL = "jdbc:postgresql://localhost/postgres";// args[0]; //jdbc:postgresql://localhost/sample....
                                                                  // error with the url"postgresql" indicate type, can't
                                                                  // use triton...also affect the result
        String username = "postgres";// args[1]; //postgres
        String password = "12345";// args[2]; //12345
        connectAndTest(connURL, username, password);
        
    }

    // javac FTM.java -cp .:postgresql-42.5.0.jar
    // java -cp .:postgresql-42.5.0.jar FTM

    // with package net... get to direction containing net
    // javac net/jsql.java -cp .:postgresql-42.5.0.jar
    // java -cp .:postgresql-42.5.0.jar net/jsql


    public static Connection default_conn(){
        try {
            String connURL = "jdbc:postgresql://localhost/emailhelp";
            String userName = "postgres";
            String password = "123456";
            Connection conn = DriverManager.getConnection(connURL, userName, password);
            // Statement stmt = conn.createStatement();
            System.out.println("connected");

            // conn.close();
            return conn;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static String[][] string_java_sql(String[][] java_string, String[] java_string_name, String[][] sql_schema) {
        // for sql_schema, 1st line name, 2nd line type
        // return the string for sql according to column name -> column type
        // get the type for each column name
        String[] java_string_type = new String[java_string_name.length];
        try{
            for(int i=0;i<java_string_name.length;i++){
                int if_find = -1;
                for(int j=0;j<sql_schema[0].length;j++)
                    if (java_string_name[i].equals(sql_schema[0][j])){
                        if_find = j;
                        java_string_type[i] = sql_schema[1][j];
                        break;
                    }
                if (if_find == -1){
                    throw new Exception(java_string_name[i]+" not found");
                }
            }

            // convert the java_string to sql_string
            String[][] sql_string = new String[java_string.length][java_string[0].length];
            for (int i=0;i<java_string.length;i++){
                for(int j=0;j<java_string[i].length;j++){
                    String typename = java_string_type[j];
                    String sql_now = java_string[i][j];
                    if (typename.equals("varchar")){
                        sql_now = "'"+sql_now+"'";
                    } else if (typename.equals("bool") || typename.equals("int4") || typename.equals("serial") || typename.equals("float4") || typename.equals("text") || typename.equals("time") || typename.equals("date") || typename.equals("timestamp")){
                        // same
                        sql_now = "'"+sql_now+"'"; // 'true' is also fine
                    }  else {
                        throw new Exception("unhandled type "+typename);
                    }
                    sql_string[i][j] = sql_now;
                }
            }

            return sql_string;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }




    public static void string2_print(String[][] res){
        System.out.println("total rows = "+res.length);
        int l = 650;
        if (res.length < l)
            l = res.length;
        for (int i = 0; i < l; i++) {
            for (int j = 0; j < res[i].length; j++)
                System.out.print(res[i][j] + "\t\t");
            System.out.println();
        }
        System.out.println("total rows = "+res.length);
    }


    public static void connectAndTest(String connURL, String userName, String password) {
        try {
            Connection conn = DriverManager.getConnection(connURL, userName, password);
            Statement stmt = conn.createStatement();
            System.out.println("connected");

            /*
            String table_name = "undergraduates";
            String[] schema = new String[]{"student_id","ucsd_college"};
            String[][] data = new String[][]{{"'A0000'","'Thurgood Marshall'"}};
            FTM.tablename_update(conn,table_name, schema,data);*/

            /*
            String[] schema = new String[] {"section_id","s_year","m_type","m_day","start_t","end_t","room","meeting_id"};
            String[] type_ = new String[] {"int4","int4","varchar","varchar","time","time","varchar","serial"};
            String[] data_origin = new String[]{"120","2023","DI","M","12:30:00","12:50:00","","10"};

            String[][] data = FTM.string_java_sql(new String[][]{data_origin}, schema, new String[][]{schema,type_});
            string2_print(data);
            */

            add_trigger_constraint(stmt);



            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static String[] get_current_quarter_start(){
        // get the current quarter and start of day

        // Getting the current date value
        LocalDate curr = LocalDate.now();
        int year = curr.getYear();

        // compare to get know th quarter
        LocalDate winter = LocalDate.of(year, 1, 4);
        LocalDate spring = LocalDate.of(year, 3, 29);
        LocalDate summer1 = LocalDate.of(year, 7, 3);
        LocalDate summer2 = LocalDate.of(year, 8, 7);
        LocalDate fall = LocalDate.of(year, 9, 8);

        String quarter = null;
        String quarter_start = null;
        if (curr.isAfter(winter) && curr.isBefore(spring)) {
            quarter = "Winter";
            quarter_start = winter.toString();
        } else if (curr.isAfter(spring) && curr.isBefore(summer1)) {
            quarter = "Spring";
            quarter_start = spring.toString();
        } else if (curr.isAfter(summer1) && curr.isBefore(summer2)) {
            quarter = "Summer I";
            quarter_start = summer1.toString();
        } else if (curr.isAfter(summer2) && curr.isBefore(fall)) {
            quarter = "Summer II";
            quarter_start = summer2.toString();
        } else if (curr.isAfter(fall)) {
            quarter = "Fall";
            quarter_start = fall.toString();
        }
        // System.out.println(quarter);
        return new String[]{quarter, quarter_start};
    }

    public static int get_current_year(){
        // Getting the current date value
        LocalDate curr = LocalDate.now();
        int year = curr.getYear();
        // System.out.println(quarter);
        return year;
    }

    public static String[][] tablename_schema(Connection conn, String table_name) {
        // ArrayList<String[]> res = new ArrayList<String[]>();
        String[][] res = new String[2][];
        try {
            DatabaseMetaData metadata = conn.getMetaData();
            ResultSet rs = metadata.getColumns(null, null , table_name, null); // schemaName ??

            // schema name & type
            ArrayList<String> column_name = new ArrayList<String>();
            ArrayList<String> column_type = new ArrayList<String>();
            while (rs.next()) {
                //String columnName = rs.getString("COLUMN_NAME");
                //String columnType = rs.getString("TYPE_NAME");
                //System.out.println(columnName + " " + columnType);
                column_name.add(rs.getString("COLUMN_NAME"));
                column_type.add(rs.getString("TYPE_NAME"));
            }
            res[0] = column_name.toArray(new String[0]);
            res[1] = column_type.toArray(new String[0]);

            return res;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }


    // get result from query
    public static String[][] query_schema_data(Statement stmt, String query) {
        // stmt.executeUpdate();
        // Use execute() when you want to execute any SQL statement and may expect multiple result sets or no result at all.
        // Use executeUpdate() when you want to execute SQL statements that modify the database and need to know the number of rows affected.
        // Use stmt.executeQuery() when executing SELECT statements that retrieve data.
        ArrayList<String[]> res = new ArrayList<String[]>();
        try {
            // ResultSet rs = stmt.executeQuery("SELECT * FROM " + table_name + ";");
            String[] query_list = query.split(";");
            int l = query_list.length;
            if (query_list[l-1].replaceAll(" ","").equals("")){
                System.out.println("last one null");
                l --;
            }

            for(int i=0; i<l-1; i++){ // maybe temporary
                System.out.println("___"+query_list[i]);
                stmt.execute(query_list[i]); // only execute last one, thus, must separate
            }

            System.out.println("___"+query_list[l-1]);
            // last one must not blank
            ResultSet rs = stmt.executeQuery(query_list[l-1]);
            
            ResultSetMetaData rsmd = rs.getMetaData();
            int columnsCount = rsmd.getColumnCount();

            // schema name
            ArrayList<String> single = new ArrayList<String>();
            for (int i = 1; i <= columnsCount; i++)
                single.add(rsmd.getColumnName(i));
            res.add(single.toArray(new String[0]));

            // schema type
            single = new ArrayList<String>();
            for (int i = 1; i <= columnsCount; i++)
                single.add(rsmd.getColumnTypeName(i));
            res.add(single.toArray(new String[0]));

            // data
            while (rs.next()) {
                single = new ArrayList<String>();
                // xx += rs.getString(1)+"<br>";
                for (int i = 1; i <= columnsCount; i++)
                    single.add(rs.getString(i));
                // xx += "__"+ rs.getString(i);
                // System.out.println(xx);
                res.add(single.toArray(new String[0]));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return res.toArray(new String[0][]);
    }

    public static String[][] tablename_schema_data(Statement stmt, String table_name) {
        // stmt.executeUpdate();
        ArrayList<String[]> res = new ArrayList<String[]>();
        try {
            ResultSet rs = stmt.executeQuery("SELECT * FROM " + table_name + ";");
            ResultSetMetaData rsmd = rs.getMetaData();
            int columnsCount = rsmd.getColumnCount();

            // schema name
            ArrayList<String> single = new ArrayList<String>();
            for (int i = 1; i <= columnsCount; i++)
                single.add(rsmd.getColumnName(i));
            res.add(single.toArray(new String[0]));

            // schema type
            single = new ArrayList<String>();
            for (int i = 1; i <= columnsCount; i++)
                single.add(rsmd.getColumnTypeName(i));
            res.add(single.toArray(new String[0]));

            // data
            while (rs.next()) {
                single = new ArrayList<String>();
                // xx += rs.getString(1)+"<br>";
                for (int i = 1; i <= columnsCount; i++)
                    single.add(rs.getString(i));
                // xx += "__"+ rs.getString(i);
                // System.out.println(xx);
                res.add(single.toArray(new String[0]));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return res.toArray(new String[0][]);
    }

    public static String[] table_name_all(DatabaseMetaData metadata){
        try {
            // Get database metadata
            ArrayList<String> res = new ArrayList<String>();

            // Get all table names
            ResultSet resultSet = metadata.getTables(null, null, null, new String[]{"TABLE"});
            while (resultSet.next()) {
                res.add(resultSet.getString("TABLE_NAME"));
                // System.out.println(resultSet.getString("TABLE_NAME"));
            }
            return res.toArray(new String[0]);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static HashMap<String,HashMap<String,String>> tablename_key_foreigntable_key(Connection conn, String table_name) {
        // get all tables who have a foreign key referencing this table
        try {
            DatabaseMetaData metadata = conn.getMetaData();
            // get all the table
            String[] tables = table_name_all(metadata);

            // foreign_table, primary_key ---> foreign_key   .... translate
            HashMap<String,HashMap<String,String>> foreign_primary_key = new HashMap<String,HashMap<String,String>>();
            for (String table_f:tables){
                ResultSet resultSet = metadata.getImportedKeys(null, null, table_f);
                while (resultSet.next()) {
                    String pkTableName = resultSet.getString("PKTABLE_NAME");
                    String pkColumnName = resultSet.getString("PKCOLUMN_NAME");
                    // String fkName = resultSet.getString("FK_NAME");
                    String fkColumnName = resultSet.getString("FKCOLUMN_NAME");
                    if (pkTableName.equals(table_name)){
                        if(!foreign_primary_key.containsKey(table_f)){
                            foreign_primary_key.put(table_f,new HashMap<String,String>());
                        }
                        foreign_primary_key.get(table_f).put(pkColumnName,fkColumnName);
                    }
                    /*
                    System.out.println("Foreign Key Name: " + fkName);
                    System.out.println("Foreign Key Column: " + fkColumnName);
                    System.out.println("Primary Key Table: " + pkTableName);
                    System.out.println("Primary Key Column: " + pkColumnName);
                    System.out.println();*/
                }
                // try to print out
                if (foreign_primary_key.containsKey(table_f)){
                    System.out.println("=============check for "+table_f+"===============");
                    HashMap<String,String> primary_foreign = foreign_primary_key.get(table_f);
                    for(String primary : primary_foreign.keySet())
                        System.out.println(primary + "  -->  " + primary_foreign.get(primary));
                }
            }
            return foreign_primary_key;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /*
     * public static String[][] tablename_schema(Statement stmt, String table_name)
     * {
     * // stmt.executeUpdate();
     * ArrayList<String[]> res = new ArrayList<String[]>();
     * try {
     * ResultSet rs = stmt.executeQuery("SELECT * FROM " + table_name + ";");
     * ResultSetMetaData rsmd = rs.getMetaData();
     * int columnsCount = rsmd.getColumnCount();
     * while (rs.next()) {
     * ArrayList<String> single = new ArrayList<String>();
     * // xx += rs.getString(1)+"<br>";
     * for (int i = 1; i <= columnsCount; i++)
     * single.add(rs.getString(i));
     * // xx += "__"+ rs.getString(i);
     * // System.out.println(xx);
     * res.add(single.toArray(new String[0]));
     * }
     * } catch (Exception e) {
     * e.printStackTrace();
     * }
     * return res.toArray(new String[0][]);
     * }
     */

    public static String[] tablename_insert(Statement stmt, String table_name, String[] schema, String[][] datas) {
        String sql_insert = "";
        try {
            sql_insert = "INSERT INTO "+table_name+" (";
            // schema
            for (int i = 0; i < schema.length - 1; i++)
                sql_insert += schema[i] + ",";
            sql_insert += schema[schema.length - 1] + ") VALUES ";

            // value
            for (int k=0;k<datas.length;k++){
                String[] data = datas[k];

                sql_insert += "(";

                for (int i = 0; i < data.length - 1; i++)
                    sql_insert += data[i] + ",";
                sql_insert +=  data[data.length - 1] + ")";

                // for different data
                if (k == datas.length-1)
                    sql_insert += ";";
                else
                    sql_insert += ",";
            }

            System.out.println(sql_insert);

            // execute
            stmt.executeUpdate(sql_insert);

            return new String[]{"T", sql_insert};
        } catch (SQLException e) {
            System.out.println("sql Message: \n" + e.getMessage());
            return new String[]{"F", sql_insert, e.getMessage()};
        } catch (Exception e) {
            e.printStackTrace();
            return new String[]{"F", sql_insert};
        }
    }

    public static boolean[] schema_ifprimary(Connection conn, String table_name, String[] schema){

        // what if no primary key ???  incomplete primary key ???
        // check schema completeness to avoid update to much date ???
        try {
            DatabaseMetaData metadata = conn.getMetaData();
            ResultSet rs = metadata.getPrimaryKeys(null, null, table_name);
            boolean[] if_primary = new boolean[schema.length];
            for(int i=0;i<schema.length;i++)    if_primary[i] = false;
            while (rs.next()) {
                String columnName = rs.getString("COLUMN_NAME"); // this is what we want
                int find_idx=-1;
                for(int i=0;i<schema.length;i++)
                    if (columnName.equals(schema[i])){
                        find_idx = i;
                        break;
                    }
                if (find_idx != -1){
                    if_primary[find_idx] = true;
                } else {
                    throw new Exception("primary key not foundd ! ___"+columnName);
                }

                // String pkName = rs.getString("PK_NAME");
                // int keySeq = rs.getShort("KEY_SEQ");
                // System.out.println("Primary key column: " + columnName); // this
                // System.out.println("Primary key name: " + pkName);
                // System.out.println("Primary key sequence: " + keySeq);
            }
            return if_primary;

        }  catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static boolean[] schema_ifforeign(Connection conn, String table_name, String[] schema){
        // what if no primary key ???  incomplete primary key ???
        // check schema completeness to avoid update to much date ???
        try {
            DatabaseMetaData metadata = conn.getMetaData();
            ResultSet rs = metadata.getImportedKeys(null, null, table_name);
            boolean[] if_primary = new boolean[schema.length];
            for(int i=0;i<schema.length;i++)    if_primary[i] = false;
            while (rs.next()) {
                String columnName = rs.getString("FKCOLUMN_NAME"); // this is what we want
                int find_idx=-1;
                for(int i=0;i<schema.length;i++)
                    if (columnName.equals(schema[i])){
                        find_idx = i;
                        break;
                    }
                if (find_idx != -1){
                    if_primary[find_idx] = true;
                } else {
                    throw new Exception("foreign key not foundd ! ___"+columnName);
                }

                // String pkName = rs.getString("PK_NAME");
                // int keySeq = rs.getShort("KEY_SEQ");
                // System.out.println("Primary key column: " + columnName); // this
                // System.out.println("Primary key name: " + pkName);
                // System.out.println("Primary key sequence: " + keySeq);
            }
            return if_primary;

        }  catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // make sure entity has no foreign key...to distinguish from primary key
    public static String[] tablename_update(Connection conn, String table_name, String[] schema, String[][] datas) {
        String sql_s = "";
        try {
            // first get the primary primary
            boolean[] if_primary = schema_ifprimary(conn, table_name,schema);
            boolean[] if_foreign = schema_ifforeign(conn, table_name,schema);

            /**/
            // get last idx to avoid add ,
            int last_primary_idx = -1;
            int last_foreign_idx = -1;
            int last_non_idx = -1;
            for(int i=0;i<schema.length;i++)
                if(if_primary[i]){
                    last_primary_idx = i;
                    System.out.println(schema[i]+"--->primary");
                }else if(if_foreign[i]){
                    last_foreign_idx = i;
                    System.out.println(schema[i]+"--->foreign");
                }else{
                    last_non_idx = i;
                    System.out.println(schema[i]+"--->non");
                }
            // System.out.println("last_primary_idx = "+last_primary_idx);
            // System.out.println("last_foreign_idx = "+last_foreign_idx);
            // System.out.println("last_non_idx = "+last_non_idx);

            //UPDATE student set first_name = 'Jonathan', last_name = 'Doe', middle_name = 'J.', social_security_num = '123-45-6789', is_enrolled = true WHERE student_id = '1001';
            // must use ', not " ... error
            // update data
            Statement stmt = conn.createStatement();

            for (int k=0;k<datas.length;k++){
                String[] data = datas[k];
                String sql_update = "UPDATE "+table_name+" set ";
                // update part---non
                for (int i=0;i<=last_non_idx;i++)
                    if (!(if_primary[i])){ // ||if_foreign[i] // now not use foreign key and primary at same time...thus just exclude primary key...or miss Info
                    // UPDATE weekly_meeting set m_type='DI',m_day='M',start_t='08:30:00',end_t='11:00:00',room='' where meeting_id='1'
                        sql_update += schema[i] +"="+ data[i];
                        if (i < last_non_idx)
                            sql_update += ",";
                    }
// UPDATE student set first_name='Alice',last_name='Smith,middle_name='L.',social_security_num='123-45-6789',is_enrolled=true where student_id='1002';

                // where part---by primary key..if there is primary key
                sql_update += " where ";
                if(last_primary_idx >=0){ // use primary key or foreign key
                    for (int i=0;i<=last_primary_idx;i++)
                        if (if_primary[i]){
                            sql_update += schema[i] +"="+ data[i];
                            if (i < last_primary_idx)
                                sql_update += " and ";
                        }
                } else{
                    // where by foreign key
                    sql_update += "(";
                    for (int i=0;i<=last_foreign_idx;i++)
                        if (if_foreign[i]){
                            sql_update += schema[i] +"="+ data[i];
                            if (i < last_foreign_idx)
                                sql_update += " and ";
                        }
                    sql_update += ")";
                }

                sql_update += ";";


                System.out.println(sql_update);
                sql_s += sql_update;

                // execute
                stmt.executeUpdate(sql_update);
            }

            return new String[]{"T", sql_s};
        } catch (SQLException e) {
            System.out.println("sql Message: \n" + e.getMessage());
            return new String[]{"F", sql_s, e.getMessage()};
        } catch (Exception e) {
            e.printStackTrace();
            return new String[]{"F", sql_s};
        }
    }

    public static boolean tablename_delete_old(Connection conn, String table_name, String[] schema, String[][] datas) {
        // this only delete itself
        try {
            // first get the primary primary
            boolean[] if_primary = schema_ifprimary(conn, table_name,schema);

            /**/
            // get last idx to avoid add ,
            int last_primary_idx = -1;
            int last_non_idx = -1;
            for(int i=0;i<schema.length;i++)
                if(if_primary[i])
                    last_primary_idx = i;
                else
                    last_non_idx = i;

            //UPDATE student set first_name = 'Jonathan', last_name = 'Doe', middle_name = 'J.', social_security_num = '123-45-6789', is_enrolled = true WHERE student_id = '1001';
            // must use ', not " ... error
            // delete data
            Statement stmt = conn.createStatement();

            for (int k=0;k<datas.length;k++){
                String[] data = datas[k];
                String sql_delete = "delete from "+table_name;
                // where part---primary
                sql_delete += " where ";
                for (int i=0;i<=last_primary_idx;i++)
                    if (if_primary[i]){
                        sql_delete += schema[i] +"="+ data[i];
                        if (i < last_primary_idx)
                            sql_delete += " and ";
                    }
                sql_delete += ";";


                System.out.println(sql_delete);

                // execute
                stmt.executeUpdate(sql_delete);
            }

            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static String[] tablename_delete(Connection conn, String table_name, String[] schema, String[][] datas) {
        // this try to delete all related
        String sql_s = "";
        try {
            boolean[] if_primary = schema_ifprimary(conn, table_name,schema);
            boolean[] if_foreign = schema_ifforeign(conn, table_name,schema);

            /**/
            // get last idx to avoid add ,
            int last_primary_idx = -1;
            int last_foreign_idx = -1;
            int last_non_idx = -1;
            for(int i=0;i<schema.length;i++)
                if(if_primary[i]){
                    last_primary_idx = i;
                }else if(if_foreign[i]){
                    last_foreign_idx = i;
                }else{
                    last_non_idx = i;
                }

            // get all related foreign table_key
            HashMap<String,HashMap<String,String>> foreign_table_key= tablename_key_foreigntable_key( conn, table_name);

            //UPDATE student set first_name = 'Jonathan', last_name = 'Doe', middle_name = 'J.', social_security_num = '123-45-6789', is_enrolled = true WHERE student_id = '1001';
            // must use ', not " ... error
            // update data
            Statement stmt = conn.createStatement();

            // create cmd, then execute
            HashMap<String,String> sql_related_delete = new HashMap<String,String>();
            String sql_delete;
            // for (int k=0;k<datas.length;k++){
            // String[] data = datas[k];
            for(String[] data : datas){
                // start
                for(String table_t : foreign_table_key.keySet())
                    sql_related_delete.put(table_t, "delete from " + table_t + " where ");
                sql_delete = "delete from "+table_name + " where "; // can't merge, itself no need to translate

                // where part---primary

                // related
                for(String table_f : foreign_table_key.keySet()){
                    String related_sql = sql_related_delete.get(table_f);
                    HashMap<String,String> primary_key_translate = foreign_table_key.get(table_f);
                    for(int i=0;i<=last_primary_idx;i++)
                        if (if_primary[i]){
                            System.out.println(i+"\t"+last_primary_idx);
                            related_sql +=  primary_key_translate.get(schema[i]) +"="+ data[i];
                            if (i < last_primary_idx)
                                related_sql += " and "; // should change the symbol from sql_delete to related_sql
                        }
                    related_sql += " ;";
                    sql_related_delete.put(table_f, related_sql);
                    System.out.println(related_sql);
                    // record
                    sql_s += table_f +"   --->   " + sql_related_delete.get(table_f); //  + "\n"; can't contain line break
                }

                // itself---primary key
                if (last_primary_idx >= 0){
                for (int i=0;i<=last_primary_idx;i++)
                    if (if_primary[i]){
                        sql_delete += schema[i] +"="+ data[i];
                        if (i < last_primary_idx)
                            sql_delete += " and ";
                    }
                } else {
                    // where by foreign key
                    sql_delete += "(";
                    for (int i=0;i<=last_foreign_idx;i++)
                        if (if_foreign[i]){
                            sql_delete += schema[i] +"="+ data[i];
                            if (i < last_foreign_idx)
                                sql_delete += " and ";
                        }
                    sql_delete += ")";
                }

                sql_delete += " ;";
                // record
                sql_s += sql_delete;


                // print out + execute
                for(String table_f : sql_related_delete.keySet()){
                    System.out.println(table_f +"   --->   " + sql_related_delete.get(table_f));
                    stmt.executeUpdate(sql_related_delete.get(table_f));
                }
                System.out.println(sql_delete);
                stmt.executeUpdate(sql_delete);
            }

            return new String[]{"T", sql_s};
        } catch (SQLException e) {
            System.out.println("sql Message: \n" + e.getMessage());
            return new String[]{"F", sql_s, e.getMessage()};
        } catch (Exception e) {
            e.printStackTrace();
            return new String[]{"F", sql_s};
        }
    }

    public static String[] path_execute_sql(String sql_path, Connection conn) throws Exception{
        Statement stmt = conn.createStatement();
        return path_execute_sql(sql_path, stmt);
    }
    public static String[] path_execute_sql(String sql_path, Statement stmt){
        String sql_s="";
        try{
            BufferedReader reader = new BufferedReader(new FileReader(sql_path));

            StringBuilder sqlBuilder = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                sqlBuilder.append(line);
                sqlBuilder.append("\n");
            }

            sql_s = sqlBuilder.toString();

            return string_execute_sql(sql_s, conn);
        }   catch (Exception e) {
            e.printStackTrace();

            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            e.printStackTrace(pw);
            String stackTrace = sw.toString();
            return new String[]{"F", sql_s, stackTrace};
        }
    }
    public static String[] string_execute_sql(String sql_s, Connection conn){
        try{
            Statement stmt = conn.createStatement();

            String[] query_list = query.split(";");
            int l = query_list.length;
            for(int i=0; i<l-1; i++){ // maybe temporary
                System.out.println("___"+query_list[i]);
                stmt.execute(query_list[i]); // only execute last one, thus, must separate
            }

            stmt.executeUpdate(sql_s);


            System.out.println("SQL file executed successfully.");

            return new String[]{"T", sql_s};
        } catch (SQLException e) {
            System.out.println("sql Message: \n" + e.getMessage());
            return new String[]{"F", sql_s, e.getMessage()};
        } catch (Exception e) {
            e.printStackTrace();

            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            e.printStackTrace(pw);
            String stackTrace = sw.toString();
            return new String[]{"F", sql_s, stackTrace};
        }
    }

    public static String[] add_trigger_constraint(Statement stmt){
        return path_execute_sql("net/trigger_constraint.sql", stmt); // path is defined as relative to the running path, namely the java xxxx running path
    }


    public static String delete_db(String database_name){
        String xx="not executed";
        try{
            // DriverManager.registerDriver(new org.postgresql.Driver());
            // Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost/tritonlink?user=postgres&password=123456");
            Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost/postgres?user=postgres&password=12345");
            Statement stmt = conn.createStatement();

            // conn.setAutoCommit(false); // DROP DATABASE cannot run inside a transaction block
            // Drop the database
            String sql = "DROP DATABASE "+database_name+";";
            stmt.executeUpdate(sql);
            // Commit the transaction
            // conn.commit();

            xx = "success";

            conn.close();

        }catch(Exception e){
            e.printStackTrace();
            xx = "fail___"+xx;
        }

        return xx;
    }

    public static String create_db(String database_name){
        String xx="not executed";
        try{
            // DriverManager.registerDriver(new org.postgresql.Driver());
            // Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost/tritonlink?user=postgres&password=123456");
            Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost/postgres?user=postgres&password=12345");
            Statement stmt = conn.createStatement();

            // conn.setAutoCommit(false);
            // create the database
            String sql = "CREATE DATABASE "+database_name+";";
            stmt.executeUpdate(sql);
            // Commit the transaction
            // conn.commit();

            xx = "success";

            conn.close();

        }catch(Exception e){
            e.printStackTrace();
            xx = "fail___"+xx;
        }

        return xx;
    }

    public static boolean exist_db(String database_name){
        boolean ifexist = false;
        try{
            // DriverManager.registerDriver(new org.postgresql.Driver());
            // Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost/tritonlink?user=postgres&password=123456");
            Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost/postgres?user=postgres&password=12345");
            Statement stmt = conn.createStatement();

            /*
            conn.setAutoCommit(false);
            // Drop the database
            String sql = "DROP DATABASE "+database_name+";";
            stmt.executeUpdate(sql);
            // Commit the transaction
            conn.commit();
            */

            // Query the system catalog to check if the database exists
            String sql = "SELECT datname FROM pg_catalog.pg_database WHERE datname = '" + database_name + "'";
            ResultSet resultSet = stmt.executeQuery(sql);

            if (resultSet.next()) {
                ifexist = true;
            } else {
                ifexist = false;
            }

            conn.close();

        }catch(Exception e){
            e.printStackTrace();
        }

        return ifexist;

    }

}


