cd /var/lib/pm2node/Dogwatch/backend
npm install
cd /home/bf/pm2node/Dogwatch/frontend
npm install --production=false
npm run build
cd /var/lib/pm2node/Dogwatch
pm2 delete dogwatch_frontend
pm2 delete dogwatch_backend
pm2 restart ecoststem.config.js --env prod
pm2 save