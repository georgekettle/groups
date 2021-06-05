const colors = require('tailwindcss/colors')

module.exports = {
  important: true,
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
      green: colors.emerald,
      contrast: {
        light: '#FFD8AB',
        DEFAULT: '#FF804B',
        dark: '#F1682F',
      },
      primary: {
        light: '#f5e6ff',
        DEFAULT: '#764296',
        dark: '#63387d',
      },
      link: '#3dadff',
      kale: '#03363D',
      paleKale: '#17494D',
      nessie: '#BDD9D7',
      oatMilk: '#FFF3E1',
      karl: '#fbf8f5',
      tofu: '#fffdfb',
      coral: '#ff884f',
      blazeOrange: '#ff5f01',
    },
    extend: {
      animation: {
        'ping-once': 'ping 1s cubic-bezier(0, 0, 0.2, 1)',

      }
    },
  },
  variants: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/forms'),
  ],
}
