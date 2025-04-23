fetch('/quotes')
  .then(res => res.json())
  .then(data => {
    const ul = document.getElementById('quote-list');
    data.forEach(quote => {
      const li = document.createElement('li');
      li.textContent = `${quote.author}: "${quote.quote}"`;
      ul.appendChild(li);
    });
  });
