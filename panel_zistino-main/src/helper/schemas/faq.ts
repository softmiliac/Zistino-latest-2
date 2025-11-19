import * as Yup from 'yup';

export const FaqSchema = Yup.object().shape({
    title: Yup.string()
        .min(3, 'Too Short!')
        .max(50, 'Too Long!')
        .required('title is required'),

    description: Yup.string()
        .min(5, 'Too Short!')
        .max(200, 'Too Long!')
        .required('description is required'),

    categoryId: Yup.string().required('category is required'),

    locale: Yup.string().required('locale is required'),
});
