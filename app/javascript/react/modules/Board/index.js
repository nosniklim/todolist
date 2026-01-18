import React, { useEffect, useState } from 'react';
import ListLane from './ListLane';

export default function Board() {
  const [lists, setLists] = useState([]);

  useEffect(() => {
    fetch('/api/v1/board', { credentials: 'include' })
      .then((r) => r.json())
      .then((data) => setLists(data.lists || []))
      .catch(console.error);
  }, []);

  return <ListLane lists={lists} />;
}
