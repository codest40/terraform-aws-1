fetch('https://api.quotable.io/quotes?limit=5')
  .then(res => res.json())
  .then(data => {
    const ul = document.getElementById('quote-list');
    data.results.forEach(quote => {
      const li = document.createElement('li');
      li.textContent = `${quote.author}: "${quote.content}"`;
      ul.appendChild(li);
    });
  })
  .catch(err => {
    console.error('Failed to load quotes:', err);
  });
