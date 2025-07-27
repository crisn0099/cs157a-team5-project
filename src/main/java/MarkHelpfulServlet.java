import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/MarkHelpfulServlet")
public class MarkHelpfulServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int reviewID = Integer.parseInt(request.getParameter("reviewID"));
        int userID = Integer.parseInt(request.getParameter("userID"));
        boolean isHelpful = request.getParameter("isHelpful").equals("1");

        try (Connection conn = MysqlCon.getConnection()) {
            // check if user already voted
            String checkSql = "SELECT isHelpful FROM review_helpfulness WHERE reviewID = ? AND userID = ?";
            try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                checkPs.setInt(1, reviewID);
                checkPs.setInt(2, userID);
                ResultSet rs = checkPs.executeQuery();

                if (rs.next()) {
                    boolean existingVote = rs.getBoolean("isHelpful");
                    if (existingVote == isHelpful) {
                        // remove vote
                        String deleteSql = "DELETE FROM review_helpfulness WHERE reviewID = ? AND userID = ?";
                        try (PreparedStatement deletePs = conn.prepareStatement(deleteSql)) {
                            deletePs.setInt(1, reviewID);
                            deletePs.setInt(2, userID);
                            deletePs.executeUpdate();
                        }
                    } else {
                        // change vote
                        String updateSql = "UPDATE review_helpfulness SET isHelpful = ? WHERE reviewID = ? AND userID = ?";
                        try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                            updatePs.setBoolean(1, isHelpful);
                            updatePs.setInt(2, reviewID);
                            updatePs.setInt(3, userID);
                            updatePs.executeUpdate();
                        }
                    }
                } else {
                    // add new vote
                    String insertSql = "INSERT INTO review_helpfulness (reviewID, userID, isHelpful) VALUES (?, ?, ?)";
                    try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                        insertPs.setInt(1, reviewID);
                        insertPs.setInt(2, userID);
                        insertPs.setBoolean(3, isHelpful);
                        insertPs.executeUpdate();
                    }
                }
            }

            String gameID = request.getParameter("gameID");
            response.sendRedirect("GamePage.jsp?gameID=" + gameID);
        } catch (SQLException e) {
            response.getWriter().println("Failed to process vote: " + e.getMessage());
        }
    }
}
