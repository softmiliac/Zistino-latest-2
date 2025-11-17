import { GoogleGenAI } from "@google/genai";

if (!process.env.API_KEY) {
    console.warn("API_KEY environment variable not set. Gemini API calls will fail.");
}

const ai = new GoogleGenAI({ apiKey: process.env.API_KEY! });

// Helper to convert file to base64
const fileToGenerativePart = async (file: File) => {
  const base64EncodedDataPromise = new Promise<string>((resolve) => {
    const reader = new FileReader();
    reader.onloadend = () => {
        if (typeof reader.result === 'string') {
            resolve(reader.result.split(',')[1]);
        } else {
            resolve('');
        }
    };
    reader.readAsDataURL(file);
  });
  return {
    inlineData: { data: await base64EncodedDataPromise, mimeType: file.type },
  };
};


export const getSortingInstruction = async (itemName: string, image?: File): Promise<string> => {
    try {
        const prompt = `شما یک متخصص در زمینه مدیریت پسماند و بازیافت هستید. دستورالعمل‌های واضح، مختصر و کاربردی برای تفکیک این آیتم ارائه دهید: "${itemName}". اگر تصویری ارائه شده است، از آن برای شناسایی دقیق‌تر آیتم استفاده کنید. پاسخ خود را با فرمت مارک‌داون ساده بنویسید. یک عنوان برای آیتم، توضیحی کوتاه در مورد کاری که باید انجام شود و یک لیست کوتاه از اقدامات کلیدی ارائه دهید.`;

        const parts: any[] = [{ text: prompt }];

        if (image) {
            const imagePart = await fileToGenerativePart(image);
            parts.push(imagePart);
        }

        const response = await ai.models.generateContent({
            model: 'gemini-2.5-flash',
            contents: { parts: parts },
            config: {
                temperature: 0.2,
            }
        });

        if (response && response.text) {
            return response.text;
        } else {
            return "متاسفانه، نتوانستم دستورالعملی برای این آیتم ایجاد کنم. لطفاً دوباره تلاش کنید.";
        }
    } catch (error) {
        console.error("Error calling Gemini API:", error);
        return "هنگام دریافت دستورالعمل تفکیک خطایی رخ داد. لطفاً کلید API و اتصال شبکه خود را بررسی کنید.";
    }
};