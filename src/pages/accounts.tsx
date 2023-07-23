"use client";

import { signOut, useSession } from "next-auth/react";

const Accounts = () => {
  const { data: session } = useSession();

  return (
    <>
      <pre>{JSON.stringify(session?.user)}</pre>
      <button
        className="p-2 rounded-xl bg-blue-700 text-white font-bold"
        onClick={() => signOut({ callbackUrl: "https://localhost:3000" })}
      >
        Sign Out
      </button>
    </>
  );
};

export default Accounts;
