<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>

<%
    request.setAttribute("currentPage", "FeaturedGames");
    Integer userID = (Integer) session.getAttribute("userID");
%>

<jsp:include page="navbar.jsp" />

<html>
<head>
  <title>Featured Games</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    html {
      overflow-y: scroll;
    }

    body {
      background-color: #121212;
      font-family: Arial, sans-serif;
      color: white;
      margin: 0;
      padding: 0;
    }

    h2 {
      text-align: center;
      margin-top: 20px;
      font-size: 2.5em;
    }

    .carousel-container {
      position: relative;
      width: 90%;
      height: 550px;
      margin: 40px auto 60px;
      overflow: hidden;
      display: flex;
      justify-content: center;
      align-items: center;
    }

    .carousel-item {
      position: absolute;
      opacity: 0;
      transition: opacity 1s ease-in-out;
      width: 100%;
      display: flex;
      justify-content: center;
      align-items: center;
    }

    .carousel-item.active {
      opacity: 1;
      z-index: 1;
    }

    .carousel-item img {
      max-height: 500px;
      border-radius: 10px;
      box-shadow: -5px 5px 20px rgba(102, 0, 204, 0.5);
    }

    .carousel-info h3 {
      color: white;
      text-align: center;
      margin-top: 20px;
      font-size: 1.8em;
    }
  </style>
</head>
<body>

<h2>Featured Games</h2>

<div class="carousel-container">
  <div class="carousel-item active">
    <div style="text-align: center;">
      <a href="GamePage.jsp?gameID=28">
        <img src="https://media.rawg.io/media/games/b7d/b7d3f1715fa8381a4e780173a197a615.jpg" alt="Featured Game 1">
      </a>
      <div class="carousel-info">
        <h3>Horizon Zero Dawn</h3>
      </div>
    </div>
  </div>

  <div class="carousel-item">
    <div style="text-align: center;">
      <a href="GamePage.jsp?gameID=6">
        <img src="https://media.rawg.io/media/games/5f1/5f1399f755ed3a40b04a9195f4c06be5.jpg" alt="Featured Game 2">
      </a>
      <div class="carousel-info">
        <h3>Marvel's Spider-Man Remastered</h3>
      </div>
    </div>
  </div>

  <div class="carousel-item">
    <div style="text-align: center;">
      <a href="GamePage.jsp?gameID=65">
        <img src="https://media.rawg.io/media/games/f90/f90ee1a4239247a822771c40488e68c5.jpg" alt="Featured Game 3">
      </a>
      <div class="carousel-info">
        <h3>Dead Cells</h3>
      </div>
    </div>
  </div>
  
  <div class="carousel-item">
    <div style="text-align: center;">
      <a href="GamePage.jsp?gameID=32">
        <img src="https://media.rawg.io/media/games/490/49016e06ae2103881ff6373248843069.jpg" alt="Featured Game 4">
      </a>
      <div class="carousel-info">
        <h3>Metal Gear Solid V: The Phantom Pain</h3>
      </div>
    </div>
  </div>
  
  <div class="carousel-item">
    <div style="text-align: center;">
      <a href="GamePage.jsp?gameID=48">
        <img src="https://media.rawg.io/media/games/e42/e428e70c97064037326d7863a43a0454.jpg" alt="Featured Game 5">
      </a>
      <div class="carousel-info">
        <h3>Injustice 2</h3>
      </div>
    </div>
  </div>
</div>

<script>
  let index = 0;
  const items = document.querySelectorAll('.carousel-item');
  if (items.length > 0) {
    items[index].classList.add('active');
    setInterval(() => {
      items[index].classList.remove('active');
      index = (index + 1) % items.length;
      items[index].classList.add('active');
    }, 4000);
  }
</script>

</body>
</html>
