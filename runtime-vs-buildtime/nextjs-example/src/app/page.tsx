export default function Home() {
  const version = process.env.NEXT_PUBLIC_APP_VERSION;
  const buildTime = process.env.NEXT_PUBLIC_BUILD_TIMESTAMP;

  return (
    <footer>
      <span>version{version}</span>
      <br></br>
      <span>Built: {buildTime}</span>
    </footer>
  );
}