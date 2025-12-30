import React, { useEffect, useState } from "react";

function Card({ listId, card }) {
  return (
    <a href={`/lists/${listId}/cards/${card.id}`} className="cardDetail_link">
      <div className="card">
        <h3 className="card_title">{card.title}</h3>
        {card.memo?.length > 0 && (
          <div className="card_detail is-exist">
            <i className="fas fa-bars"></i>
          </div>
        )}
      </div>
    </a>
  );
}

function ListLane({ lists }) {
  return (
    <div class="listWrapper">
      {lists.map((list) => (
        <div class="list">
          <div class="list_header">
            <h2 class="list_header_title">{list.title}</h2>
            <div class="list_header_action">
              <a href={`/lists/${list.id}`} data-method="delete" data-confirm={`Are you sure you want to remove '${list.title}'?`}>
                <i className="fas fa-trash" />
              </a>
              <a href={`/lists/${list.id}/edit`}>
                <i className="fas fa-pen" />
              </a>
            </div>
          </div>
          <div className="cardWrapper">
            {list.cards?.map((card) => (
              <Card listId={list.id} card={card} />
            ))}
            <div className="addCard">
              <i className="far fa-plus-square"></i>
              <a href={`/lists/${list.id}/cards/new`} className="addCard_link">
                Add a card...
              </a>
            </div>
          </div>
        </div>
      ))}
    </div>
  );
}

export default function Board() {
  const [lists, setLists] = useState([]);

  useEffect(() => {
    fetch("/api/v1/lists", { credentials: "include" })
      .then((r) => r.json())
      .then((data) => setLists(data.lists || []))
      .catch(console.error);
  }, []);

  return (
    <ListLane lists={lists} />
  );
}
