const express = require('express');
const app = express();
const port = 3000;

const quotes = [
  { id: 1, author: "Albert Einstein", quote: "Imagination is more important than knowledge." },
  { id: 2, author: "Yoda", quote: "Do or do not. There is no try." },
  { id: 3, author: "Oscar Wilde", quote: "Be yourself; everyone else is already taken." }
];

app.get('/', (req, res) => res.send('Welcome to Quotes API!'));

app.get('/quotes', (req, res) => {
  res.json(quotes);
});

app.get('/quotes/:id', (req, res) => {
  const quote = quotes.find(q => q.id == req.params.id);
  if (quote) res.json(quote);
  else res.status(404).send({ error: 'Quote not found' });
});

app.listen(port, () => {
  console.log(`Quotes API is listening at http://localhost:${port}`);
});
