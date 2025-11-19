import axios from "axios";

// 🔹 آدرس پایه API را از env می‌گیریم؛
// در Render مقدار VITE_API_BASE_URL می‌شود دامنه بک‌اند
// و در حالت لوکال اگر env نبود، می‌رود روی 127.0.0.1
const API_BASE =
  import.meta.env.VITE_API_BASE_URL || "http://127.0.0.1:8000";

// اینجا مثل قبل /api/v1 را اضافه می‌کنیم
const APP_API_URL = `${API_BASE}/api/v1`;

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
