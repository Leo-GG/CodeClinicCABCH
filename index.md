The Code Clinic is an informal meeting for students and postdocs to get together and help each other review, discuss and fix their code (MATLAB or otherwise).

It is held (approximately at best) every two weeks at the CABHC meeting room.

Visit the [RESOURCES](Resources.html) page for links to useful tutorials and documentation.

# Posts
<ul>
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url | prepend:site.baseurl  }}">{{ post.date | date_to_string }}: {{post.title }}</a>
    </li>
  {% endfor %}
</ul>

