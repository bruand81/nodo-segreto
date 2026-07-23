enum CaesarAlphabetMode { italian, english }

const String italianAlphabet = 'ABCDEFGHILMNOPQRSTUVZ';
const String englishAlphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

String alphabetFor(CaesarAlphabetMode mode) {
  return switch (mode) {
    CaesarAlphabetMode.italian => italianAlphabet,
    CaesarAlphabetMode.english => englishAlphabet,
  };
}
