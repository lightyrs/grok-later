d = document
e = encodeURIComponent
u = e(location.href)
r = Math.random()
b = #{bookmarklet_path}
if d.body
  s = d.createElement("script")
  s.src = b + "/start?url=" + u + "&r=" + r
  d.body.appendChild s
else
  location.href = b + "/add?url=" + u + "&r=" + r
