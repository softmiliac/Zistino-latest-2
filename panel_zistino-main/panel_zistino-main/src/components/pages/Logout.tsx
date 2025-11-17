import { FC } from "react";
import { useAuth } from "../../components/hooks";

const Logout: FC = () => {
    const { logout } = useAuth();
    logout();
    return <div></div>;
};

export default Logout;
