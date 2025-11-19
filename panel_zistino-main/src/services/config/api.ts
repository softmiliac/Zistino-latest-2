import axios from "axios";
import { APP_API_URL } from "../../";

const token = localStorage.getItem("token_zistino");

const config = token
  ? {
      baseURL: APP_API_URL,
      headers: { Authorization: `Bearer ${token}` },
    }
  : {
      baseURL: APP_API_URL,
    };

const api = axios.create(config);

const { get, post, delete: remove, put } = api;

export { get, post, remove, put };
