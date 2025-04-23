const assert = require('assert');

const quotes = [
  { id: 1, author: "Albert Einstein", quote: "Imagination is more important than knowledge." },
  { id: 2, author: "Yoda", quote: "Do or do not. There is no try." }
];

assert.strictEqual(quotes.length, 2, 'There should be 2 quotes');
console.log('✅ All tests passed!');
