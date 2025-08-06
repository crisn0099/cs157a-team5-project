import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/SubmitReviewServlet")
public class SubmitReviewServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int gameID = Integer.parseInt(request.getParameter("gameID"));
        int userID = Integer.parseInt(request.getParameter("userID"));
        int rating = Integer.parseInt(request.getParameter("starRating"));
        String reviewText = request.getParameter("textReview");

        try (Connection conn = MysqlCon.getConnection()) {
            String sql = "INSERT INTO game_review (gameID, userID, starRating, textReview) VALUES (?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, gameID);
                ps.setInt(2, userID);
                ps.setInt(3, rating);
                ps.setString(4, reviewText);
                ps.executeUpdate();
            }
            response.sendRedirect("GamePage.jsp?gameID=" + gameID);
        } catch (SQLException e) {
            response.getWriter().println("Failed to submit review: " + e.getMessage());
        }
    }
}
