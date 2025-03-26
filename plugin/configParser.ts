const args = process.argv.slice(2);
const [projectRoot, configFile] = args;
global.__dirname = projectRoot;

import(`${projectRoot}/${configFile}`).then((config) => {
  const l = config?.default({}, {})?.resolve?.alias || {};
  Object.entries(l).forEach(([k, v]) => console.log(k, v))
})
