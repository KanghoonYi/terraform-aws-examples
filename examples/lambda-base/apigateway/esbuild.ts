import { globSync } from 'glob';
import esbuildModule from 'esbuild';
import { packageJsonPlugin } from 'esbuild-plugin-package-json';
import * as process from 'node:process';

const entryFilePaths = globSync('src/functions/**/handler.ts', {
  // root: path.resolve(__dirname, 'src/functions'),
  nodir: true,
  dotRelative: true,
});

(async () => {
  const buildResult = await esbuildModule.build({
    plugins: [packageJsonPlugin()],
    entryPoints: entryFilePaths,
    entryNames: '[dir]/[name]',
    outbase: './',
    outdir: '.esbuild',
    bundle: true,
    platform: 'node',
    tsconfig: './tsconfig.json',
    treeShaking: true,
    packages: 'external',
    sourcemap: true,
    minify: process.env.NODE_ENV === 'production',
    format: 'esm',
  });
  return buildResult;
})().catch((reason) => {
  console.error(reason);
  process.exit(1);
});
