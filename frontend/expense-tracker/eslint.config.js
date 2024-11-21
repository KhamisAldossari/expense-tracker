export default [
  {
    files: ['src/**/*.{js,ts,tsx}'],
    rules: {
      // Enforce semicolons
      semi: ['error', 'always'],

      // Prefer single quotes
      quotes: ['error', 'single'],

      // Disallow unused variables
      'no-unused-vars': ['warn'],

      // Require explicit return types for functions
      '@typescript-eslint/explicit-function-return-type': 'warn',

      // Enforce consistent indentation
      indent: ['error', 2],

      // Require trailing commas
      'comma-dangle': ['error', 'always-multiline'],

      // Prevent unused imports
      'import/no-unused-modules': ['warn', { unusedExports: true }],
    },
  },
];
