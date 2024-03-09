import config from '../config';
import fs from 'fs';
import axios from 'axios';

export const getSecrets = async () => {
  if (fs.existsSync(config.firebase.key_path)) {
    return;
  }
  try {
    const response = await axios({
      url: config.firebase.key_url,
      method: 'GET',
      responseType: 'stream',
    });
    const fileStream = await fs.createWriteStream(config.firebase.key_path);
    response.data.pipe(fileStream);
  } catch (error) {
    throw new Error('Error downloading keys');
  }
};
