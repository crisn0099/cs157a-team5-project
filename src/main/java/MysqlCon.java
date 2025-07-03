import java.sql.*;

public class MysqlCon {
    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Use .cj for MySQL 8+
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/games_for_me?autoReconnect=true&useSSL=false",
                "root",
                "db_password"
            );

            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM Student");

            while (rs.next()) {
                System.out.println(rs.getInt(1) + " " +
                                   rs.getString(2) + " " +
                                   rs.getString(3));
            }

            con.close();
        } catch (Exception e) {
            System.out.println("SQLException caught: " + e);
        }
    }
}