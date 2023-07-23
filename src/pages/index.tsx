import { Inter } from "next/font/google";
import { signIn } from "next-auth/react";

const inter = Inter({ subsets: ["latin"] });

export default function Home() {
  return (
    <main
      className={`flex min-h-screen flex-col items-center justify-between p-24 ${inter.className}`}
    >
      <div className="z-10 w-full max-w-5xl items-center justify-between font-mono text-sm lg:flex">
        <button
          className="rounded-xl bg-blue-700 p-2 font-bold text-white"
          onClick={() =>
            signIn("github", { callbackUrl: "http://localhost:3000/accounts" })
          }
        >
          Sign In
        </button>
      </div>
    </main>
  );
}
