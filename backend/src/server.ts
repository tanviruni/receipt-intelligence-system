import { createApp } from './app';
import { config } from './config/env';

const app = createApp();

app.listen(config.port, () => {
  console.log(`[server] running on http://localhost:${config.port}`);
  console.log(`[server] environment: ${config.nodeEnv}`);
});
