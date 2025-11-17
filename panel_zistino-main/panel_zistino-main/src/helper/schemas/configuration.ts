import * as Yup from 'yup';

export const ConfigurationSchema = Yup.object().shape({
    name: Yup.string()
        .min(3, 'Too Short!')
        .max(50, 'Too Long!')
        .required('name is required'),

    value: Yup.string().required('value is required'),

    type: Yup.number().required('type is required'),

});
