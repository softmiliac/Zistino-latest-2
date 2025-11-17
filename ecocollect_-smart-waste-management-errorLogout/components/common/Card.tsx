
import React from 'react';

// FIX: Update CardProps to extend React.HTMLAttributes<HTMLDivElement> to allow passing props like onClick.
interface CardProps extends React.HTMLAttributes<HTMLDivElement> {
  children: React.ReactNode;
  className?: string;
}

const Card: React.FC<CardProps> = ({ children, className = '', ...props }) => {
  const cardClasses = `bg-surface rounded-xl shadow-sm border border-gray-100 p-4 ${className}`;

  // FIX: Pass the rest of the props to the underlying div element.
  return <div className={cardClasses} {...props}>{children}</div>;
};

export default Card;
