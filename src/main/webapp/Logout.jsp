<%
session.invalidate(); // ends the session and removes userID
response.sendRedirect("MainPage.jsp"); // redirect to main page
%>
