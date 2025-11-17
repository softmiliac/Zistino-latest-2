import React, { useState, useRef } from 'react';
import { getSortingInstruction } from '../services/geminiService';
import Button from './common/Button';
import Card from './common/Card';
import Icon from './common/Icon';
import ReactMarkdown from 'https://esm.sh/react-markdown@9';

const SortingGuide: React.FC = () => {
  const [itemName, setItemName] = useState('');
  const [imageFile, setImageFile] = useState<File | null>(null);
  const [instruction, setInstruction] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [previewUrl, setPreviewUrl] = useState<string | null>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const handleImageChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (file) {
      setImageFile(file);
      setPreviewUrl(URL.createObjectURL(file));
    }
  };

  const handleSubmit = async (event: React.FormEvent) => {
    event.preventDefault();
    if (!itemName) {
      alert('لطفاً نام آیتم را وارد کنید.');
      return;
    }
    setIsLoading(true);
    setInstruction('');
    const result = await getSortingInstruction(itemName, imageFile || undefined);
    setInstruction(result);
    setIsLoading(false);
  };

  const triggerFileSelect = () => fileInputRef.current?.click();
  
  const clearImage = () => {
    setImageFile(null);
    setPreviewUrl(null);
    if(fileInputRef.current) {
      fileInputRef.current.value = "";
    }
  };


  return (
    <div className="space-y-4">
      <Card>
        <div className="text-center">
            <Icon name="Guide" className="w-10 h-10 mx-auto text-primary mb-2" />
            <h2 className="text-xl font-bold">راهنمای هوشمند تفکیک</h2>
            <p className="text-textSecondary mt-1">در مورد تفکیک زباله شک دارید؟ از دستیار هوش مصنوعی ما بپرسید!</p>
        </div>
      </Card>
      
      <Card>
        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label htmlFor="item-name" className="block text-sm font-medium text-textPrimary mb-1">
              نام آیتم
            </label>
            <input
              id="item-name"
              type="text"
              value={itemName}
              onChange={(e) => setItemName(e.target.value)}
              placeholder="مثلاً «جعبه پیتزا» یا «بطری پلاستیکی»"
              className="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-primary focus:border-primary"
              required
            />
          </div>
          
          <div>
            <label className="block text-sm font-medium text-textPrimary mb-1">
              آپلود تصویر (اختیاری)
            </label>
            <input
              type="file"
              accept="image/*"
              ref={fileInputRef}
              onChange={handleImageChange}
              className="hidden"
            />
            {previewUrl ? (
                <div className="mt-2 relative">
                    <img src={previewUrl} alt="Preview" className="w-full h-40 object-contain rounded-md bg-gray-100" />
                    <button type="button" onClick={clearImage} className="absolute top-2 left-2 bg-white rounded-full p-1 shadow-md text-gray-600 hover:text-red-500">
                        <Icon name="Trash" className="w-5 h-5"/>
                    </button>
                </div>
            ) : (
                <button type="button" onClick={triggerFileSelect} className="w-full flex flex-col items-center justify-center px-6 py-8 border-2 border-dashed border-gray-300 rounded-md text-sm text-textSecondary hover:border-primary">
                    <Icon name="Camera" className="w-8 h-8 mb-2" />
                    <span>برای آپلود عکس کلیک کنید</span>
                </button>
            )}
          </div>

          <Button type="submit" disabled={isLoading} fullWidth>
            {isLoading ? (
                <>
                    <Icon name="Loading" className="w-5 h-5 ms-2 animate-spin" />
                    در حال تحلیل...
                </>
            ) : (
                'دریافت راهنمای تفکیک'
            )}
          </Button>
        </form>
      </Card>

      {instruction && (
        <Card>
          <div className="prose prose-sm max-w-none prose-h3:text-primary prose-strong:text-textPrimary prose-li:marker:text-primary">
            <ReactMarkdown>{instruction}</ReactMarkdown>
          </div>
        </Card>
      )}
    </div>
  );
};

export default SortingGuide;