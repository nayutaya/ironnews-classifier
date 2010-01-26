#! ruby -Ku

require "cgi"

require "config"

File.open("dump.html", "wb") { |file|
  file.puts(%|<html>|)
  file.puts(%| <head>|)
  file.puts(%|  <title>単純ベイズ分類器 評価</title>|)
  file.puts(%| </head>|)
  file.puts(%| <body>|)
  file.puts(%|  <table border="1">|)
  file.puts(%|   <tr>|)
  file.puts(%|    <th>記事ID</th>|)
  file.puts(%|    <th>記事名</th>|)
  file.puts(%|    <th>旧</td>|)
  file.puts(%|    <th>新</td>|)
  file.puts(%|   </tr>|)

  articles = Article.all(:order => [:article_id.asc])
  articles.each { |article|
    file.puts(%|   <tr>|)
    file.puts(%|    <td>#{article.article_id}</td>|)
    file.puts(%|    <td>#{CGI.escapeHTML(article.title)}</td>|)
    file.puts(%|    <td>#{CGI.escapeHTML(article.local_bayes1.to_s)}</td>|)
    file.puts(%|    <td>#{CGI.escapeHTML(article.gae_bayes1.to_s)}</td>|)
    file.puts(%|   </tr>|)
  }

  file.puts(%|  </table>|)
  file.puts(%| </body>|)
  file.puts(%|</html>|)
  file.puts(%||)
}
