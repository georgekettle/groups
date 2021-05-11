const colors = require('tailwindcss/colors')

module.exports = {
  purge: [],
  darkMode: false, // or 'media' or 'class'
  theme: {
    fontFamily: {
      sans: ['Shape', 'Helvetica', 'sans-serif'],
      serif: ['Morion'],
      mono: ['League Mono']
    },
    colors: {
      transparent: 'transparent',
      current: 'currentColor',
      black: colors.black,
      white: colors.white,
      gray: colors.trueGray,
      indigo: colors.indigo,
      red: colors.rose,
      yellow: colors.amber,
      primary: {
        light: '#BDD9D7',
        DEFAULT: '#17494D',
        dark: '#03363D',
      },
      kale: '#03363D',
      paleKale: '#17494D',
      nessie: '#BDD9D7',
      oatMilk: '#ECE0CE',
      karl: '#F3F0EE',
      tofu: '#F8F9F9',
    }
  },
  variants: {
    extend: {},
  },
  plugins: [],
}
