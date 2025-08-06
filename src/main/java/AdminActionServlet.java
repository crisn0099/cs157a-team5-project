import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/AdminActionServlet")
public class AdminActionServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int reviewID = Integer.parseInt(request.getParameter("reviewID"));
        String action = request.getParameter("action");
        String comment = request.getParameter("comment");
        int adminID = (Integer) request.getSession().getAttribute("userID");

        try (Connection conn = MysqlCon.getConnection()) {
            // update game_review
            if ("approve".equals(action)) {
                String sql = "UPDATE game_review SET isFlagged = 0, flagReason = NULL, flagComment = NULL WHERE reviewID = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, reviewID);
                    ps.executeUpdate();
                }
            } else if ("delete".equals(action)) {
                String sql = "UPDATE game_review SET isDeleted = 1 WHERE reviewID = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, reviewID);
                    ps.executeUpdate();
                }
            }

            // update admin_action_log with resolution
            String updateLog = "UPDATE admin_action_log " +
                               "SET actionType = ?, actionComment = ?, resolutionTimestamp = NOW() " +
                               "WHERE reviewID = ? AND actionType = 'flag'";
            try (PreparedStatement ps = conn.prepareStatement(updateLog)) {
                ps.setString(1, action);   // approve or delete
                ps.setString(2, comment);  // action comment
                ps.setInt(3, reviewID);
                ps.executeUpdate();
            }

            response.sendRedirect("AdminActionLog.jsp");
        } catch (SQLException e) {
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
