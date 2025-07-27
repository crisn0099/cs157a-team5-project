import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try (Connection conn = MysqlCon.getConnection()) {
            String query = "SELECT userID FROM user WHERE username = ? AND password = ?";
            try (PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setString(1, username);
                ps.setString(2, password); // compare with hash later
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    int userID = rs.getInt("userID");
                    HttpSession session = request.getSession();
                    session.setAttribute("userID", userID);
                    session.setAttribute("username", username);
                    response.sendRedirect("MainPage.jsp");
                } else {
                    request.setAttribute("error", "Invalid login");
                    request.getRequestDispatcher("Login.jsp").forward(request, response);
                }
            }
        } catch (SQLException e) {
            response.getWriter().println("Login error: " + e.getMessage());
        }
    }
}
