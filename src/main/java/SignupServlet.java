import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");

        try (Connection conn = MysqlCon.getConnection()) {
            String query = "INSERT INTO user (username, password, email) VALUES (?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setString(1, username);
                ps.setString(2, password); // hash later
                ps.setString(3, email);
                ps.executeUpdate();
                response.sendRedirect("Login.jsp");
            }
        } catch (SQLException e) {
            if (e.getErrorCode() == 1062) {
                response.getWriter().println("That username is already taken. Please try a different one.");
            } else {
                response.getWriter().println("Signup failed: " + e.getMessage());
            }
        }
    }
}
