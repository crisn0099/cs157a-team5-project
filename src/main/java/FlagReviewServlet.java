import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/FlagReviewServlet")
public class FlagReviewServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int reviewID = Integer.parseInt(request.getParameter("reviewID"));
        int userID = Integer.parseInt(request.getParameter("userID"));
        String reason = request.getParameter("flagReason");
        String comment = request.getParameter("flagComment");

        try (Connection conn = MysqlCon.getConnection()) {
            // mark the review as flagged and add reason + comment
            String updateReview = "UPDATE game_review SET isFlagged = 1, flagReason = ?, flagComment = ? WHERE reviewID = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateReview)) {
                ps.setString(1, reason);
                ps.setString(2, comment);
                ps.setInt(3, reviewID);
                ps.executeUpdate();
            }

            // add to admin_action_log 
            String insertLog = "INSERT INTO admin_action_log (userID, reviewID, actionType, actionComment, timestamp) VALUES (?, ?, 'flag', '', NOW())";
            try (PreparedStatement ps = conn.prepareStatement(insertLog)) {
                ps.setInt(1, userID);
                ps.setInt(2, reviewID);
                ps.executeUpdate();
            }

            String gameID = request.getParameter("gameID");
            response.sendRedirect("GamePage.jsp?gameID=" + gameID);
        } catch (SQLException e) {
            response.getWriter().println("Failed to flag review: " + e.getMessage());
        }
    }
}
