import { FC } from 'react';
import { HiX } from 'react-icons/hi';

export const Modal: FC<any> = ({ html, children, title }) => {
    return (
        <>
            <input type='checkbox' id={html} className='modal-toggle' />
            <div className='modal'>
                <div className='modal-box bg-secondary-light-100 dark:bg-secondary-dark-100 dark:text-white md:w-[400px]'>
                    <div className='flex items-start justify-between'>
                        <h2 className='mb-8 text-lg'>{title}</h2>
                        <label className='block cursor-pointer' htmlFor={html}>
                            <HiX className='text-xl' />
                        </label>
                    </div>

                    {children}
                </div>
            </div>
        </>
    );
};
