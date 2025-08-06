import java.sql.*;

public class MysqlCon {
    public static void main(String[] args) {
        try {
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/games_for_me?autoReconnect=true&useSSL=false",
                "root",
                "DBpassword"
            );

            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM game");

            while (rs.next()) {
                System.out.println(
                    rs.getInt("gameID") + " " +
                    rs.getString("title") + " " +
                    rs.getString("releaseDate")
                );
            }

            con.close();
        } catch (Exception e) {
            System.out.println("SQLException caught: " + e);
        }
    }

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); 
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        return DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/games_for_me?autoReconnect=true&useSSL=false",
            "root",
            "DBpassword"
        );
    }
}
