import React from 'react';

export default function CardItem({ listId, card }) {
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
