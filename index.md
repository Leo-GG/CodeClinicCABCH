The Code Clinic is held every two weeks at the CABHC meeting room.

Visit the [RESOURCES](Resources.html) page for links to useful tutorials and documentation.

# Posts
<ul>
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url | prepend:site.baseurl  }}">{{ post.date | date_to_string }}: {{post.title }}</a>
    </li>
  {% endfor %}
</ul>

